/**
 * inspector.js — Right panel inspector
 * Handles: showing cell/free-rect details, preview canvas, sprite save
 */

const InspectorModule = (() => {
  let currentData = null; // { region, blockIndex, frameIndex, collision }
  let currentSpriteId = null; // To track existing sprites for updates
  let showPreviewGrid = false;
  let showPreviewCenter = true;

  const $ = sel => document.querySelector(sel);

  function _drawPreview(region, image, collision = null) {
    const pc = $('#preview-canvas');
    if (!image || !region) return;
    const pCtx = pc.getContext('2d');
    pCtx.clearRect(0, 0, pc.width, pc.height);
    // Checker bg
    for (let cy = 0; cy < pc.height; cy += 8) {
      for (let cx = 0; cx < pc.width; cx += 8) {
        pCtx.fillStyle = ((cx / 8 + cy / 8) % 2 === 0) ? '#1c2128' : '#161b22';
        pCtx.fillRect(cx, cy, 8, 8);
      }
    }
    pCtx.imageSmoothingEnabled = false;
    pCtx.drawImage(image,
      region.x, region.y, region.w, region.h,
      0, 0, pc.width, pc.height
    );

    // Draw Alignment Guides
    if (showPreviewGrid) {
      pCtx.lineWidth = 1;
      pCtx.strokeStyle = 'rgba(255, 255, 255, 0.15)';
      // 3x3 Grid
      for (let i = 1; i < 3; i++) {
        pCtx.beginPath();
        pCtx.moveTo((pc.width / 3) * i, 0); pCtx.lineTo((pc.width / 3) * i, pc.height);
        pCtx.stroke();
        pCtx.beginPath();
        pCtx.moveTo(0, (pc.height / 3) * i); pCtx.lineTo(pc.width, (pc.height / 3) * i);
        pCtx.stroke();
      }
    }

    if (showPreviewCenter) {
      pCtx.lineWidth = 1;
      pCtx.strokeStyle = 'rgba(255, 255, 255, 0.4)';
      pCtx.setLineDash([2, 2]);
      pCtx.beginPath();
      pCtx.moveTo(pc.width / 2, 0); pCtx.lineTo(pc.width / 2, pc.height);
      pCtx.stroke();
      pCtx.beginPath();
      pCtx.moveTo(0, pc.height / 2); pCtx.lineTo(pc.width, pc.height / 2);
      pCtx.stroke();
      pCtx.setLineDash([]);
    }

    // Draw Collision overlay (High contrast)
    if (collision && collision.type !== 'none') {
      const scaleX = pc.width / region.w;
      const scaleY = pc.height / region.h;
      
      const ox = collision.ox || 0;
      const oy = collision.oy || 0;
      const centerX = (region.w / 2 + ox) * scaleX;
      const centerY = (region.h / 2 + oy) * scaleY;

      pCtx.lineWidth = 3;
      pCtx.strokeStyle = 'rgba(0, 0, 0, 0.8)';
      
      if (collision.type === 'circle') {
        const rad = (collision.radius || 32) * scaleX;
        pCtx.beginPath();
        pCtx.arc(centerX, centerY, rad, 0, Math.PI * 2);
        pCtx.stroke(); // Dark outline
        pCtx.strokeStyle = '#00ff00';
        pCtx.lineWidth = 1.5;
        pCtx.stroke(); // Green inner
        pCtx.fillStyle = 'rgba(0, 255, 0, 0.2)';
        pCtx.fill();
      } else if (collision.type === 'rect') {
        const rw = (collision.w || 64) * scaleX;
        const rh = (collision.h || 64) * scaleY;
        pCtx.beginPath();
        pCtx.rect(centerX - rw/2, centerY - rh/2, rw, rh);
        pCtx.stroke(); // Dark outline
        pCtx.strokeStyle = '#00ff00';
        pCtx.lineWidth = 1.5;
        pCtx.stroke(); // Green inner
        pCtx.fillStyle = 'rgba(0, 255, 0, 0.2)';
        pCtx.fill();
      }
    }
  }

  function initUI() {
    $('#insp-col-type').addEventListener('change', (e) => {
      const type = e.target.value;
      $('#col-params-circle').style.display = type === 'circle' ? 'block' : 'none';
      $('#col-params-rect').style.display   = type === 'rect'   ? 'block' : 'none';
      if (currentData) {
        currentData.collision = currentData.collision || { type: 'none' };
        currentData.collision.type = type;
        if (type === 'circle' && !currentData.collision.radius) currentData.collision.radius = currentData.region.w / 2.5;
        if (type === 'rect' && !currentData.collision.w) { currentData.collision.w = currentData.region.w * 0.8; currentData.collision.h = currentData.region.h * 0.8; }
        _refreshUI();
      }
    });

    $('#insp-scale').addEventListener('input', (e) => {
      if (currentData) {
        currentData.scale = parseFloat(e.target.value) || 1.0;
        _refreshUI();
      }
    });

    ['radius', 'w', 'h', 'ox', 'oy'].forEach(key => {
      $(`#insp-col-${key}`).addEventListener('input', (e) => {
        if (currentData) {
          currentData.collision = currentData.collision || { type: $('#insp-col-type').value };
          currentData.collision[key] = parseFloat(e.target.value) || 0;
          _refreshUI();
        }
      });
    });

    $('#btn-preview-guides').addEventListener('click', () => {
      showPreviewGrid = !showPreviewGrid;
      $('#btn-preview-guides').classList.toggle('active', showPreviewGrid);
      _refreshUI();
    });

    $('#btn-preview-center').addEventListener('click', () => {
      showPreviewCenter = !showPreviewCenter;
      $('#btn-preview-center').classList.toggle('active', showPreviewCenter);
      _refreshUI();
    });
    $('#btn-preview-center').classList.add('active'); // Center active by default
  }

  function showCell(cell, image) {
    const { blockIndex, frameIndex, rect } = cell;
    const existing = App.getSpriteByBlock(blockIndex);
    
    currentSpriteId = existing ? existing.id : null;
    currentData = { 
      region: { x: Math.round(rect.x), y: Math.round(rect.y), w: Math.round(rect.w), h: Math.round(rect.h) }, 
      blockIndex, 
      frameIndex,
      scale: existing ? (existing.scale || 1.0) : 1.0,
      collision: existing ? JSON.parse(JSON.stringify(existing.collision || { type: 'none' })) : { type: 'none' }
    };

    _updateInputs(existing);
    _drawPreview(currentData.region, image, currentData.collision);
  }

  function showSprite(sp, image) {
    currentSpriteId = sp.id;
    currentData = {
      region: { ...sp.region },
      blockIndex: sp.blockIndex,
      frameIndex: sp.frameIndex,
      scale: sp.scale || 1.0,
      collision: JSON.parse(JSON.stringify(sp.collision || { type: 'none' }))
    };

    _updateInputs(sp);
    _drawPreview(currentData.region, image, currentData.collision);
  }

  function showFreeRect(rect) {
    currentSpriteId = null;
    currentData = { 
      region: { x: rect.x, y: rect.y, w: rect.w, h: rect.h }, 
      blockIndex: -1, 
      frameIndex: -1,
      scale: 1.0,
      collision: { type: 'none' }
    };
    _updateInputs(null);
    _drawPreview(rect, CanvasModule.getImage(), currentData.collision);
  }

  function _updateInputs(sp) {
    $('#inspector-empty').style.display = 'none';
    $('#inspector-content').style.display = '';

    const r = currentData.region;
    $('#insp-x').value = r.x;
    $('#insp-y').value = r.y;
    $('#insp-w').value = r.w;
    $('#insp-h').value = r.h;
    $('#insp-block').value = currentData.blockIndex === -1 ? '—' : currentData.blockIndex;
    $('#insp-frame').value = currentData.frameIndex === -1 ? '—' : currentData.frameIndex;

    $('#insp-name').value     = sp ? sp.name : (currentData.blockIndex === -1 ? 'custom_sprite' : `sprite_${currentData.blockIndex}`);
    $('#insp-pivot-x').value  = sp ? sp.pivot.x : 0.5;
    $('#insp-pivot-y').value  = sp ? sp.pivot.y : 0.5;
    $('#insp-tags').value     = sp ? sp.tags.join(', ') : '';
    $('#insp-scale').value    = currentData.scale;

    const col = currentData.collision;
    $('#insp-col-type').value = col.type;
    $('#col-params-circle').style.display = col.type === 'circle' ? 'block' : 'none';
    $('#col-params-rect').style.display   = col.type === 'rect'   ? 'block' : 'none';
    $('#insp-col-radius').value = col.radius || 32;
    $('#insp-col-w').value      = col.w || 64;
    $('#insp-col-h').value      = col.h || 64;
    $('#insp-col-ox').value     = col.ox || 0;
    $('#insp-col-oy').value     = col.oy || 0;
  }

  function nudge(dx, dy) {
    if (!currentData) return;
    currentData.region.x += dx;
    currentData.region.y += dy;
    _refreshUI();
  }

  function autoFit() {
    if (!currentData) return;
    const img = CanvasModule.getImage();
    if (!img) return;

    // Expand search area slightly to find "loose" sprites
    const searchRect = {
      x: Math.max(0, currentData.region.x - 10),
      y: Math.max(0, currentData.region.y - 10),
      w: currentData.region.w + 20,
      h: currentData.region.h + 20
    };

    const bounds = CanvasModule.findTightBounds(searchRect);
    if (bounds) {
      // Center current cell size over the found bounds
      const centerX = bounds.x + bounds.w / 2;
      const centerY = bounds.y + bounds.h / 2;
      
      currentData.region.x = Math.round(centerX - currentData.region.w / 2);
      currentData.region.y = Math.round(centerY - currentData.region.h / 2);
      
      _refreshUI();
    } else {
      alert("No opaque pixels found near this area.");
    }
  }

  function _refreshUI() {
    if (!currentData) return;
    const r = currentData.region;
    $('#insp-x').value = r.x;
    $('#insp-y').value = r.y;
    $('#insp-w').value = r.w;
    $('#insp-h').value = r.h;
    _drawPreview(r, CanvasModule.getImage(), currentData.collision);
    $('#sel-info-text').textContent = `Adjusted Rect(${r.x}, ${r.y}, ${r.w}, ${r.h})`;
  }

  function getCurrentData() { return currentData; }
  function getCurrentSpriteId() { return currentSpriteId; }

  return { initUI, showCell, showSprite, showFreeRect, getCurrentData, getCurrentSpriteId, nudge, autoFit };
})();
