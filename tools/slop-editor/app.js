/**
 * app.js — SlopEditor Main Controller
 * State management, event wiring, project CRUD
 */

// ═══════════════════════════════════════ STATE ══
const App = (() => {
  let state = _defaultProject();
  let isDirty = false;
  let loadedImageSrc = null; // data URL of the image
  let currentExportTab = 'json';

  function _defaultProject() {
    return {
      name: 'untitled',
      spritesheet: '',
      layout: {
        type: 'NESTED_GRID',
        columns: 4,
        rows: 4,
        sub_columns: 4,
        sub_rows: 4
      },
      sprites: [],
      animations: []
    };
  }

  // ── Getters ──────────────────────────────────
  function getGridState() {
    return {
      type: state.layout.type,
      cols:    state.layout.columns,
      rows:    state.layout.rows,
      subCols: state.layout.sub_columns,
      subRows: state.layout.sub_rows
    };
  }

  function getSprites()          { return state.sprites; }
  function getAnimations()       { return state.animations; }
  function getSpriteById(id)     { return state.sprites.find(s => s.id === id) || null; }
  function getSpriteByBlock(idx) { return state.sprites.find(s => s.blockIndex === idx) || null; }
  function markDirty()           { isDirty = true; _updateTitle(); }
  function updateZoomDisplay()   { $('#zoom-display').textContent = Math.round(CanvasModule.getZoom() * 100) + '%'; }

  // ── Project CRUD ─────────────────────────────
  function newProject() {
    if (isDirty && !confirm('Discard unsaved changes?')) return;
    state = _defaultProject();
    isDirty = false;
    loadedImageSrc = null;
    CanvasModule.clearSelection();
    _syncGridUI();
    _renderSpriteList();
    _renderAnimList();
    _updateInfoBar();
    _updateTitle();
    $('#canvas-drop-hint').classList.remove('hidden');
  }

  function saveProject() {
    const json = ExporterModule.toJSON(state);
    ExporterModule.download(`${state.name}.json`, json);
    isDirty = false;
    _updateTitle();
  }

  function openProject(file) {
    const reader = new FileReader();
    reader.onload = e => {
      try {
        state = JSON.parse(e.target.result);
        isDirty = false;
        _syncGridUI();
        _renderSpriteList();
        _renderAnimList();
        _updateInfoBar();
        _updateTitle();
        // If a spritesheet path is stored, user must reload image manually
        if (state.spritesheet) {
          $('#info-image').textContent = state.spritesheet.split('/').pop();
        }
      } catch(ex) {
        alert('Failed to parse project file: ' + ex.message);
      }
    };
    reader.readAsText(file);
  }

  function loadImageFile(file) {
    const reader = new FileReader();
    reader.onload = e => {
      const img = new Image();
      img.onload = () => {
        loadedImageSrc = e.target.result;
        CanvasModule.loadImage(img);
        state.spritesheet = file.name;
        $('#canvas-drop-hint').classList.add('hidden');
        $('#info-image').textContent = file.name;
        $('#info-size').textContent  = `${img.width}×${img.height}`;
        _updateInfoBar();
        markDirty();
      };
      img.src = e.target.result;
    };
    reader.readAsDataURL(file);
  }

  // ── Grid Settings Sync ───────────────────────
  function _syncGridUI() {
    const l = state.layout;
    $('#grid-type').value     = l.type;
    $('#grid-cols').value     = l.columns;
    $('#grid-rows').value     = l.rows;
    $('#grid-sub-cols').value = l.sub_columns;
    $('#grid-sub-rows').value = l.sub_rows;
    _toggleNestedSettings(l.type);
  }

  function _toggleNestedSettings(type) {
    $('#nested-settings').style.display = type === 'NESTED_GRID' ? '' : 'none';
  }

  // ── Sprite Management ────────────────────────
  function saveSprite() {
    const inspData = InspectorModule.getCurrentData();
    if (!inspData) { alert('Select a cell first.'); return; }

    const name = $('#insp-name').value.trim() || `sprite_${inspData.blockIndex}`;
    const pivot = { x: parseFloat($('#insp-pivot-x').value), y: parseFloat($('#insp-pivot-y').value) };
    const tags = $('#insp-tags').value.split(',').map(t => t.trim()).filter(Boolean);

    // Check for existing sprite with same blockIndex (update)
    const existing = getSpriteByBlock(inspData.blockIndex);
    if (existing) {
      existing.name = name;
      existing.region = { ...inspData.region };
      existing.pivot = pivot;
      existing.tags  = tags;
    } else {
      state.sprites.push({
        id:         _uid(),
        name,
        blockIndex: inspData.blockIndex,
        frameIndex: inspData.frameIndex,
        region:     { ...inspData.region },
        pivot,
        tags
      });
    }

    markDirty();
    _renderSpriteList();
    _updateInfoBar();
  }

  function deleteSprite(id) {
    state.sprites = state.sprites.filter(s => s.id !== id);
    // Remove frames referencing this sprite
    state.animations.forEach(a => {
      a.frames = a.frames.filter(f => f.sprite_id !== id);
    });
    markDirty();
    _renderSpriteList();
    _renderAnimList();
    _updateInfoBar();
  }

  function _renderSpriteList() {
    const list = $('#sprite-list');
    list.innerHTML = '';
    if (state.sprites.length === 0) {
      list.innerHTML = '<div class="empty-state">No sprites saved yet</div>';
      return;
    }
    state.sprites.forEach(sp => {
      const item = document.createElement('div');
      item.className = 'list-item';

      const thumb = document.createElement('canvas');
      thumb.width = 28; thumb.height = 28;
      thumb.className = 'item-icon';
      const img = CanvasModule.getImage();
      if (img) {
        const tc = thumb.getContext('2d');
        tc.imageSmoothingEnabled = false;
        tc.drawImage(img, sp.region.x, sp.region.y, sp.region.w, sp.region.h, 0, 0, 28, 28);
      }
      item.appendChild(thumb);

      const nameEl = document.createElement('span');
      nameEl.className = 'item-name';
      nameEl.textContent = sp.name;
      item.appendChild(nameEl);

      const del = document.createElement('span');
      del.className = 'item-del';
      del.textContent = '✕';
      del.title = 'Delete sprite';
      del.addEventListener('click', e => { e.stopPropagation(); deleteSprite(sp.id); });
      item.appendChild(del);

      item.addEventListener('click', () => {
        // Show in inspector
        InspectorModule.showFreeRect(sp.region);
        $('#insp-name').value    = sp.name;
        $('#insp-pivot-x').value = sp.pivot.x;
        $('#insp-pivot-y').value = sp.pivot.y;
        $('#insp-tags').value    = sp.tags.join(', ');
        $('#insp-block').value   = sp.blockIndex;
        $('#insp-frame').value   = sp.frameIndex;
      });

      list.appendChild(item);
    });
  }

  // ── Animation Management ─────────────────────
  function addAnimation() {
    const name = prompt('Animation name:', `anim_${state.animations.length}`);
    if (!name) return;
    const anim = { id: _uid(), name: name.trim(), fps: 8, loop: true, frames: [] };
    state.animations.push(anim);
    markDirty();
    _renderAnimList();
    TimelineModule.selectAnim(anim);
  }

  function deleteAnimation(id) {
    state.animations = state.animations.filter(a => a.id !== id);
    markDirty();
    _renderAnimList();
    TimelineModule.selectAnim(null);
  }

  function addSpriteToAnimation() {
    const inspData = InspectorModule.getCurrentData();
    if (!inspData) { alert('Select a sprite from the canvas first.'); return; }

    const anims = state.animations;
    if (anims.length === 0) { alert('Create an animation first.'); return; }

    // Build select list
    const sel = $('#anim-select-target');
    sel.innerHTML = '';
    anims.forEach(a => {
      const opt = document.createElement('option');
      opt.value = a.id; opt.textContent = a.name;
      sel.appendChild(opt);
    });

    $('#modal-anim-overlay').style.display = '';
  }

  function _confirmAddToAnim() {
    const inspData = InspectorModule.getCurrentData();
    if (!inspData) return;

    const animId = $('#anim-select-target').value;
    const anim = state.animations.find(a => a.id === animId);
    if (!anim) return;

    // Find or create a sprite for current selection
    let sp = getSpriteByBlock(inspData.blockIndex);
    if (!sp) {
      // Auto-save unnamed sprite
      sp = {
        id: _uid(),
        name: $('#insp-name').value || `sprite_${inspData.blockIndex}`,
        blockIndex: inspData.blockIndex,
        frameIndex: inspData.frameIndex,
        region: { ...inspData.region },
        pivot: { x: 0.5, y: 0.5 },
        tags: []
      };
      state.sprites.push(sp);
      _renderSpriteList();
    }

    anim.frames.push({ sprite_id: sp.id, sub_index: inspData.frameIndex });
    markDirty();
    TimelineModule.selectAnim(anim);
    $('#modal-anim-overlay').style.display = 'none';
  }

  function _renderAnimList() {
    const list = $('#anim-list');
    list.innerHTML = '';
    if (state.animations.length === 0) {
      list.innerHTML = '<div class="empty-state">No animations yet</div>';
      return;
    }
    state.animations.forEach(anim => {
      const item = document.createElement('div');
      item.className = 'list-item';

      const icon = document.createElement('span');
      icon.style.fontSize = '16px';
      icon.textContent = '🎬';
      item.appendChild(icon);

      const nameEl = document.createElement('span');
      nameEl.className = 'item-name';
      nameEl.textContent = `${anim.name} (${anim.frames.length}f)`;
      item.appendChild(nameEl);

      const del = document.createElement('span');
      del.className = 'item-del';
      del.textContent = '✕';
      del.addEventListener('click', e => { e.stopPropagation(); deleteAnimation(anim.id); });
      item.appendChild(del);

      item.addEventListener('click', () => { TimelineModule.selectAnim(anim); });

      list.appendChild(item);
    });
  }

  // ── Export Modal ─────────────────────────────
  function openExportModal() {
    currentExportTab = 'json';
    _refreshExportPreview();
    $('#modal-overlay').style.display = '';
    document.querySelectorAll('.modal-tab').forEach(t => {
      t.classList.toggle('active', t.dataset.tab === 'json');
    });
  }

  function _refreshExportPreview() {
    let text = '';
    if (currentExportTab === 'json')  text = ExporterModule.toJSON(state);
    if (currentExportTab === 'tres')  text = ExporterModule.toTRES(state);
    if (currentExportTab === 'gd')    text = ExporterModule.toGDScript(state);
    $('#modal-preview').textContent = text;
  }

  function _downloadExport() {
    const ext  = currentExportTab === 'json' ? '.json' : currentExportTab === 'tres' ? '.tres' : '.gd';
    let text = '';
    if (currentExportTab === 'json')  text = ExporterModule.toJSON(state);
    if (currentExportTab === 'tres')  text = ExporterModule.toTRES(state);
    if (currentExportTab === 'gd')    text = ExporterModule.toGDScript(state);
    ExporterModule.download(state.name + ext, text);
  }

  // ── Helpers ───────────────────────────────────
  function _uid() { return Date.now().toString(36) + Math.random().toString(36).slice(2); }
  function _updateTitle() {
    const d = isDirty ? '● ' : '';
    $('#project-name-display').textContent = d + state.name;
    document.title = `${d}${state.name} — SlopEditor`;
  }
  function _updateInfoBar() {
    $('#info-sprite-count').textContent = state.sprites.length;
  }

  // ── Boot & Event Wiring ───────────────────────
  function init() {
    // Canvas
    CanvasModule.init(document.getElementById('main-canvas'), {
      onCellSelect: (cell, img) => { /* inspector already updated inside module */ },
      onFreeSelect: (rect)      => { /* inspector already updated inside module */ }
    });

    // Timeline
    TimelineModule.init();

    // Toolbar buttons
    $('#btn-new').addEventListener('click', newProject);
    $('#btn-save').addEventListener('click', saveProject);
    $('#btn-open').addEventListener('click', () => $('#file-input-json').click());
    $('#btn-load-img').addEventListener('click', () => $('#file-input-img').click());
    $('#btn-export').addEventListener('click', openExportModal);

    $('#file-input-img').addEventListener('change',  e => { if (e.target.files[0]) loadImageFile(e.target.files[0]); });
    $('#file-input-json').addEventListener('change', e => { if (e.target.files[0]) openProject(e.target.files[0]); });

    // Zoom
    $('#btn-zoom-in').addEventListener('click',  () => CanvasModule.setZoom(1.25));
    $('#btn-zoom-out').addEventListener('click', () => CanvasModule.setZoom(0.8));
    $('#btn-zoom-fit').addEventListener('click', () => CanvasModule.fitToView());

    // Grid toggles
    $('#toggle-grid').addEventListener('change', e => CanvasModule.setShowGrid(e.target.checked));
    $('#toggle-snap').addEventListener('change', e => CanvasModule.setSnapToGrid(e.target.checked));
    $('#grid-color').addEventListener('input',   e => CanvasModule.setGridColor(e.target.value));
    $('#grid-opacity').addEventListener('input', e => CanvasModule.setGridOpacity(e.target.value));

    // Grid settings
    const syncGrid = () => {
      state.layout.type       = $('#grid-type').value;
      state.layout.columns    = parseInt($('#grid-cols').value) || 4;
      state.layout.rows       = parseInt($('#grid-rows').value) || 4;
      state.layout.sub_columns = parseInt($('#grid-sub-cols').value) || 4;
      state.layout.sub_rows   = parseInt($('#grid-sub-rows').value) || 4;
      _toggleNestedSettings(state.layout.type);
      markDirty();
    };
    ['grid-type','grid-cols','grid-rows','grid-sub-cols','grid-sub-rows'].forEach(id => {
      $('#' + id).addEventListener('change', syncGrid);
      $('#' + id).addEventListener('input',  syncGrid);
    });

    // Inspector actions
    $('#btn-save-sprite').addEventListener('click', saveSprite);
    $('#btn-add-to-anim').addEventListener('click', addSpriteToAnimation);
    $('#btn-add-sprite').addEventListener('click',  saveSprite);

    // Animation actions
    $('#btn-add-anim').addEventListener('click', addAnimation);
    $('#btn-delete-anim').addEventListener('click', () => {
      const anim = TimelineModule.getCurrentAnim();
      if (anim && confirm(`Delete animation "${anim.name}"?`)) deleteAnimation(anim.id);
    });
    $('#anim-fps').addEventListener('input', e => {
      const anim = TimelineModule.getCurrentAnim();
      if (anim) { anim.fps = parseInt(e.target.value); markDirty(); }
    });
    $('#anim-loop').addEventListener('change', e => {
      const anim = TimelineModule.getCurrentAnim();
      if (anim) { anim.loop = e.target.checked; markDirty(); }
    });

    // Add to anim modal
    $('#btn-confirm-add-to-anim').addEventListener('click', _confirmAddToAnim);
    $('#modal-anim-close').addEventListener('click', () => $('#modal-anim-overlay').style.display = 'none');

    // Export modal
    $('#modal-close').addEventListener('click', () => $('#modal-overlay').style.display = 'none');
    document.querySelectorAll('.modal-tab').forEach(tab => {
      tab.addEventListener('click', () => {
        currentExportTab = tab.dataset.tab;
        document.querySelectorAll('.modal-tab').forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        _refreshExportPreview();
      });
    });
    $('#btn-download').addEventListener('click', _downloadExport);
    $('#btn-copy').addEventListener('click', () => {
      navigator.clipboard.writeText($('#modal-preview').textContent)
        .then(() => { $('#btn-copy').textContent = '✅ Copied!'; setTimeout(() => $('#btn-copy').textContent = '📋 Copy to Clipboard', 1500); });
    });

    // Close modals on overlay click
    $('#modal-overlay').addEventListener('click', e => { if (e.target === $('#modal-overlay')) $('#modal-overlay').style.display = 'none'; });
    $('#modal-anim-overlay').addEventListener('click', e => { if (e.target === $('#modal-anim-overlay')) $('#modal-anim-overlay').style.display = 'none'; });

    // Keyboard shortcuts
    document.addEventListener('keydown', e => {
      if ((e.ctrlKey || e.metaKey) && e.key === 's') { e.preventDefault(); saveProject(); }
      if ((e.ctrlKey || e.metaKey) && e.key === 'o') { e.preventDefault(); $('#file-input-json').click(); }
      if ((e.ctrlKey || e.metaKey) && e.key === 'e') { e.preventDefault(); openExportModal(); }
      if (e.key === 'Escape') {
        $('#modal-overlay').style.display = 'none';
        $('#modal-anim-overlay').style.display = 'none';
      }
    });

    _updateTitle();
    _syncGridUI();
  }

  const $ = id => document.getElementById(id);

  return {
    init, newProject, saveProject, openProject, loadImageFile,
    getGridState, getSprites, getAnimations,
    getSpriteById, getSpriteByBlock, markDirty, updateZoomDisplay
  };
})();

// ════════════════════════════════════════ BOOT ══
document.addEventListener('DOMContentLoaded', () => App.init());
