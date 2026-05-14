/**
 * inspector.js — Right panel inspector
 * Handles: showing cell/free-rect details, preview canvas, sprite save
 */

const InspectorModule = (() => {
  let currentData = null; // { region, blockIndex, frameIndex }

  const $ = id => document.getElementById(id);

  function _drawPreview(region, image) {
    const pc = $('preview-canvas');
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
  }

  function showCell(cell, image) {
    const { blockIndex, frameIndex, rect } = cell;
    currentData = { region: { x: Math.round(rect.x), y: Math.round(rect.y), w: Math.round(rect.w), h: Math.round(rect.h) }, blockIndex, frameIndex };

    $('inspector-empty').style.display = 'none';
    $('inspector-content').style.display = '';

    $('insp-x').value = Math.round(rect.x);
    $('insp-y').value = Math.round(rect.y);
    $('insp-w').value = Math.round(rect.w);
    $('insp-h').value = Math.round(rect.h);
    $('insp-block').value = blockIndex;
    $('insp-frame').value = frameIndex;

    // Auto-fill name if a sprite already exists for this block
    const existing = App.getSpriteByBlock(blockIndex);
    $('insp-name').value     = existing ? existing.name : `sprite_${blockIndex}`;
    $('insp-pivot-x').value  = existing ? existing.pivot.x : 0.5;
    $('insp-pivot-y').value  = existing ? existing.pivot.y : 0.5;
    $('insp-tags').value     = existing ? existing.tags.join(', ') : '';

    _drawPreview({ x: rect.x, y: rect.y, w: rect.w, h: rect.h }, image);

    $('sel-info-bar') && ($('sel-info-text').textContent =
      `Block ${blockIndex} · Frame ${frameIndex} · Rect(${Math.round(rect.x)}, ${Math.round(rect.y)}, ${Math.round(rect.w)}, ${Math.round(rect.h)})`);
  }

  function showFreeRect(rect) {
    currentData = { region: { x: rect.x, y: rect.y, w: rect.w, h: rect.h }, blockIndex: -1, frameIndex: -1 };

    $('inspector-empty').style.display = 'none';
    $('inspector-content').style.display = '';

    $('insp-x').value = rect.x;
    $('insp-y').value = rect.y;
    $('insp-w').value = rect.w;
    $('insp-h').value = rect.h;
    $('insp-block').value = '—';
    $('insp-frame').value = '—';
    $('insp-name').value  = 'custom_sprite';

    _drawPreview(rect, CanvasModule.getImage());
    $('sel-info-text').textContent = `Free Selection · Rect(${rect.x}, ${rect.y}, ${rect.w}, ${rect.h})`;
  }

  function getCurrentData() { return currentData; }

  return { showCell, showFreeRect, getCurrentData };
})();
