/**
 * canvas.js — Spritesheet canvas renderer
 * Handles: zoom, pan, grid overlay, cell selection, free-draw selection
 */

const CanvasModule = (() => {
  let canvas, ctx;
  let image = null;
  let zoom = 1;
  let panX = 0, panY = 0;
  let isPanning = false, panStart = { x: 0, y: 0 };
  let showGrid = true;
  let snapToGrid = true;
  let gridColor = '#00d4ff';
  let gridOpacity = 0.35;

  // Free-select state
  let isFreeSelecting = false;
  let freeStart = null, freeEnd = null;
  let freeRect = null; // { x, y, w, h } in image coords

  // Grid selection state
  let selectedCell = null; // { blockIndex, frameIndex, rect }
  let hoveredCell  = null;

  // Callbacks
  let onCellSelect  = null;
  let onFreeSelect  = null;

  function init(_canvas, callbacks = {}) {
    canvas = _canvas;
    ctx = canvas.getContext('2d');
    onCellSelect = callbacks.onCellSelect || (() => {});
    onFreeSelect = callbacks.onFreeSelect || (() => {});
    _resize();
    _bindEvents();
    requestAnimationFrame(_drawLoop);
    window.addEventListener('resize', _resize);
  }

  function _resize() {
    const area = canvas.parentElement;
    canvas.width  = area.clientWidth;
    canvas.height = area.clientHeight - 24; // minus info bar
  }

  function loadImage(img) {
    image = img;
    fitToView();
  }

  function fitToView() {
    if (!image) return;
    const margin = 40;
    const scaleX = (canvas.width  - margin * 2) / image.width;
    const scaleY = (canvas.height - margin * 2) / image.height;
    zoom = Math.min(scaleX, scaleY, 2);
    panX = (canvas.width  - image.width  * zoom) / 2;
    panY = (canvas.height - image.height * zoom) / 2;
    App.updateZoomDisplay();
  }

  function setZoom(factor, cx, cy) {
    cx = cx ?? canvas.width  / 2;
    cy = cy ?? canvas.height / 2;
    const prevZoom = zoom;
    zoom = Math.max(0.1, Math.min(32, zoom * factor));
    panX = cx - (cx - panX) * (zoom / prevZoom);
    panY = cy - (cy - panY) * (zoom / prevZoom);
    App.updateZoomDisplay();
  }

  function getZoom() { return zoom; }

  // Convert canvas coords → image coords
  function canvasToImage(cx, cy) {
    return { x: (cx - panX) / zoom, y: (cy - panY) / zoom };
  }

  // Convert image coords → canvas coords
  function imageToCanvas(ix, iy) {
    return { x: ix * zoom + panX, y: iy * zoom + panY };
  }

  function _getCellAtImagePos(ix, iy) {
    const state = App.getGridState();
    if (!image || state.type === 'FREE') return null;
    const { cols, rows, subCols, subRows } = state;

    const blockW = image.width  / cols;
    const blockH = image.height / rows;

    const bCol = Math.floor(ix / blockW);
    const bRow = Math.floor(iy / blockH);
    if (bCol < 0 || bRow < 0 || bCol >= cols || bRow >= rows) return null;

    const blockIndex = bRow * cols + bCol;
    const localX = ix - bCol * blockW;
    const localY = iy - bRow * blockH;

    let frameIndex = 0;
    let rect;

    if (state.type === 'NESTED_GRID') {
      const fW = blockW / subCols;
      const fH = blockH / subRows;
      const fCol = Math.floor(localX / fW);
      const fRow = Math.floor(localY / fH);
      if (fCol < 0 || fRow < 0 || fCol >= subCols || fRow >= subRows) return null;
      frameIndex = fRow * subCols + fCol;
      rect = {
        x: bCol * blockW + fCol * fW,
        y: bRow * blockH + fRow * fH,
        w: fW, h: fH
      };
    } else {
      rect = { x: bCol * blockW, y: bRow * blockH, w: blockW, h: blockH };
    }

    return { blockIndex, frameIndex, rect };
  }

  function _drawLoop() {
    requestAnimationFrame(_drawLoop);
    _draw();
  }

  function _draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    if (!image) return;

    // Draw image
    ctx.imageSmoothingEnabled = zoom < 1;
    ctx.drawImage(image,
      panX, panY,
      image.width  * zoom,
      image.height * zoom
    );

    if (!showGrid) return;
    _drawGrid();
    _drawHighlights();
    _drawFreeSelection();
  }

  function _drawGrid() {
    const state = App.getGridState();
    const { cols, rows, subCols, subRows } = state;

    const blockW = image.width  * zoom / cols;
    const blockH = image.height * zoom / rows;

    ctx.strokeStyle = gridColor;
    ctx.lineWidth = 1;
    ctx.globalAlpha = gridOpacity;

    // Block grid
    for (let c = 0; c <= cols; c++) {
      const x = panX + c * blockW;
      ctx.beginPath(); ctx.moveTo(x, panY); ctx.lineTo(x, panY + image.height * zoom); ctx.stroke();
    }
    for (let r = 0; r <= rows; r++) {
      const y = panY + r * blockH;
      ctx.beginPath(); ctx.moveTo(panX, y); ctx.lineTo(panX + image.width * zoom, y); ctx.stroke();
    }

    // Sub-grid (NESTED_GRID only) - dimmer
    if (state.type === 'NESTED_GRID') {
      ctx.globalAlpha = gridOpacity * 0.4;
      const fW = blockW / subCols;
      const fH = blockH / subRows;
      for (let bc = 0; bc < cols; bc++) {
        for (let br = 0; br < rows; br++) {
          for (let fc = 0; fc <= subCols; fc++) {
            const x = panX + bc * blockW + fc * fW;
            ctx.beginPath(); ctx.moveTo(x, panY + br * blockH); ctx.lineTo(x, panY + (br+1) * blockH); ctx.stroke();
          }
          for (let fr = 0; fr <= subRows; fr++) {
            const y = panY + br * blockH + fr * fH;
            ctx.beginPath(); ctx.moveTo(panX + bc * blockW, y); ctx.lineTo(panX + (bc+1) * blockW, y); ctx.stroke();
          }
        }
      }
    }

    ctx.globalAlpha = 1;
  }

  function _drawHighlights() {
    if (hoveredCell && !isFreeSelecting) {
      const r = hoveredCell.rect;
      ctx.fillStyle = 'rgba(255,255,255,0.08)';
      ctx.fillRect(panX + r.x * zoom, panY + r.y * zoom, r.w * zoom, r.h * zoom);
    }
    if (selectedCell) {
      const r = selectedCell.rect;
      ctx.strokeStyle = gridColor;
      ctx.lineWidth = 2;
      ctx.globalAlpha = 0.9;
      ctx.strokeRect(panX + r.x * zoom + 1, panY + r.y * zoom + 1, r.w * zoom - 2, r.h * zoom - 2);
      ctx.fillStyle = 'rgba(0, 212, 255, 0.12)';
      ctx.fillRect(panX + r.x * zoom, panY + r.y * zoom, r.w * zoom, r.h * zoom);
      ctx.globalAlpha = 1;
    }
    // Draw saved sprites outlines
    const sprites = App.getSprites();
    ctx.lineWidth = 1.5;
    ctx.globalAlpha = 0.6;
    sprites.forEach(sp => {
      const r = sp.region;
      ctx.strokeStyle = '#3fb950';
      ctx.strokeRect(panX + r.x * zoom, panY + r.y * zoom, r.w * zoom, r.h * zoom);
    });
    ctx.globalAlpha = 1;
  }

  function _drawFreeSelection() {
    if (!freeRect) return;
    const rx = panX + freeRect.x * zoom;
    const ry = panY + freeRect.y * zoom;
    const rw = freeRect.w * zoom;
    const rh = freeRect.h * zoom;
    ctx.setLineDash([4, 4]);
    ctx.strokeStyle = '#f0883e';
    ctx.lineWidth = 1.5;
    ctx.strokeRect(rx, ry, rw, rh);
    ctx.fillStyle = 'rgba(240,136,62,0.08)';
    ctx.fillRect(rx, ry, rw, rh);
    ctx.setLineDash([]);
  }

  function clearSelection() {
    selectedCell = null;
    freeRect = null;
  }

  function _bindEvents() {
    canvas.addEventListener('wheel', e => {
      e.preventDefault();
      const factor = e.deltaY < 0 ? 1.1 : 1 / 1.1;
      setZoom(factor, e.offsetX, e.offsetY);
    }, { passive: false });

    canvas.addEventListener('mousedown', e => {
      if (e.button === 1 || (e.button === 0 && e.altKey)) {
        isPanning = true;
        panStart = { x: e.clientX - panX, y: e.clientY - panY };
        canvas.style.cursor = 'grabbing';
        return;
      }
      if (e.button === 0) {
        const state = App.getGridState();
        if (state.type === 'FREE') {
          isFreeSelecting = true;
          freeStart = canvasToImage(e.offsetX, e.offsetY);
          freeEnd = { ...freeStart };
          freeRect = null;
        }
      }
    });

    canvas.addEventListener('mousemove', e => {
      if (isPanning) {
        panX = e.clientX - panStart.x;
        panY = e.clientY - panStart.y;
        return;
      }
      const imgPos = canvasToImage(e.offsetX, e.offsetY);
      if (isFreeSelecting) {
        freeEnd = imgPos;
        freeRect = _computeFreeRect();
        return;
      }
      hoveredCell = _getCellAtImagePos(imgPos.x, imgPos.y);
    });

    canvas.addEventListener('mouseup', e => {
      if (isPanning) { isPanning = false; canvas.style.cursor = 'crosshair'; return; }
      if (isFreeSelecting) {
        isFreeSelecting = false;
        freeRect = _computeFreeRect();
        if (freeRect && freeRect.w > 2 && freeRect.h > 2) {
          onFreeSelect(freeRect);
          InspectorModule.showFreeRect(freeRect);
        }
        return;
      }
      const imgPos = canvasToImage(e.offsetX, e.offsetY);
      const cell = _getCellAtImagePos(imgPos.x, imgPos.y);
      if (cell) {
        selectedCell = cell;
        onCellSelect(cell, image);
        InspectorModule.showCell(cell, image);
      }
    });

    canvas.addEventListener('mouseleave', () => {
      hoveredCell = null;
      if (isFreeSelecting) { isFreeSelecting = false; }
    });

    // Drag & drop image
    const area = canvas.parentElement;
    area.addEventListener('dragover',  e => { e.preventDefault(); area.classList.add('drag-over'); });
    area.addEventListener('dragleave', () => area.classList.remove('drag-over'));
    area.addEventListener('drop', e => {
      e.preventDefault();
      area.classList.remove('drag-over');
      const file = e.dataTransfer.files[0];
      if (file && file.type.startsWith('image/')) App.loadImageFile(file);
    });
  }

  function _computeFreeRect() {
    if (!freeStart || !freeEnd) return null;
    const x = Math.max(0, Math.min(freeStart.x, freeEnd.x));
    const y = Math.max(0, Math.min(freeStart.y, freeEnd.y));
    const w = Math.abs(freeEnd.x - freeStart.x);
    const h = Math.abs(freeEnd.y - freeStart.y);
    return { x: Math.round(x), y: Math.round(y), w: Math.round(w), h: Math.round(h) };
  }

  function setGridColor(c) { gridColor = c; }
  function setGridOpacity(o) { gridOpacity = parseFloat(o); }
  function setShowGrid(v) { showGrid = v; }
  function setSnapToGrid(v) { snapToGrid = v; }
  function getSelectedCell() { return selectedCell; }
  function getFreeRect() { return freeRect; }
  function getImage() { return image; }

  return {
    init, loadImage, fitToView, setZoom, getZoom,
    setGridColor, setGridOpacity, setShowGrid, setSnapToGrid,
    clearSelection, getSelectedCell, getFreeRect, getImage,
    canvasToImage, imageToCanvas
  };
})();
