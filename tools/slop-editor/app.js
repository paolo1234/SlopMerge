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

  const FRUIT_TIERS = {
    1: "Pisello",
    2: "Limone",
    3: "Kiwi",
    4: "Arancia",
    5: "Uva",
    6: "Fragola",
    7: "Melone",
    8: "Ananas",
    9: "Cocco",
    10: "Anguria",
    11: "Zucca"
  };

  function _defaultProject() {
    return {
      name: 'untitled',
      spritesheet: '',
      imageData: null, // Base64 of the image
      layout: {
        type: 'NESTED_GRID',
        columns: 4,
        rows: 4,
        sub_columns: 4,
        sub_rows: 4
      },
      sprites: [],
      animations: [],
      fruitMapping: [
        { id: 1, name: "Pisello", sprite: "" },
        { id: 2, name: "Limone", sprite: "" },
        { id: 3, name: "Kiwi", sprite: "" },
        { id: 4, name: "Arancia", sprite: "" },
        { id: 5, name: "Uva", sprite: "" },
        { id: 6, name: "Fragola", sprite: "" },
        { id: 7, name: "Melone", sprite: "" },
        { id: 8, name: "Ananas", sprite: "" },
        { id: 9, name: "Cocco", sprite: "" },
        { id: 10, name: "Anguria", sprite: "" },
        { id: 11, name: "Zucca", sprite: "" }
      ]
    };
  }

  function _migrateState(loaded) {
    const s = { ..._defaultProject(), ...loaded };
    
    // Migrate old dictionary mapping to array mapping if needed
    if (loaded.fruitMapping && !Array.isArray(loaded.fruitMapping)) {
      s.fruitMapping = Object.keys(loaded.fruitMapping).map(key => ({
        id: parseInt(key) || key,
        name: FRUIT_TIERS[key] || `Tier ${key}`,
        sprite: loaded.fruitMapping[key]
      }));
    }
    
    // If mapping is empty array but we have sprites, maybe it's an old project that needs defaults
    if (Array.isArray(s.fruitMapping) && s.fruitMapping.length === 0 && s.sprites.length > 0) {
      s.fruitMapping = _defaultProject().fruitMapping;
    }

    return s;
  }

  // ── Persistence ─────────────────────────────
  function _autoSave() {
    try {
      localStorage.setItem('slop_editor_autosave', JSON.stringify(state));
    } catch(e) {
      // Might fail if image data is too large for localStorage
      console.warn('Autosave failed (likely storage limit):', e);
    }
  }

  function _autoLoad() {
    const saved = localStorage.getItem('slop_editor_autosave');
    if (saved) {
      try {
        const loaded = JSON.parse(saved);
        state = _migrateState(loaded);
        
        if (state.imageData) {
          const img = new Image();
          img.onload = () => {
            loadedImageSrc = state.imageData;
            CanvasModule.loadImage(img);
            $('#canvas-drop-hint').classList.add('hidden');
            $('#info-image').textContent = state.spritesheet ? state.spritesheet.split('/').pop() : 'Restored';
            $('#info-size').textContent = `${img.width}×${img.height}`;
            _renderSpriteList();
          };
          img.src = state.imageData;
        }
        
        _syncGridUI();
        _renderSpriteList();
        _renderAnimList();
        _renderMappingList();
        _updateInfoBar();
        _updateTitle();
      } catch(e) {
        console.error('Failed to load autosave:', e);
      }
    }
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
  function markDirty()           { isDirty = true; _updateTitle(); _autoSave(); }
  function updateZoomDisplay()   { $('#zoom-display').textContent = Math.round(CanvasModule.getZoom() * 100) + '%'; }

  // ── Project CRUD ─────────────────────────────
  function newProject() {
    if (isDirty && !confirm('Discard unsaved changes?')) return;
    state = _defaultProject();
    isDirty = false;
    loadedImageSrc = null;
    CanvasModule.clearImage();
    CanvasModule.clearSelection();
    _syncGridUI();
    _renderSpriteList();
    _renderAnimList();
    _renderMappingList();
    _updateInfoBar();
    _updateTitle();
    $('#canvas-drop-hint').classList.remove('hidden');
    $('#info-image').textContent = 'None';
    $('#info-size').textContent  = '0×0';
  }

  function saveProject(e) {
    if (e) e.preventDefault();
    const json = ExporterModule.toJSON(state);
    ExporterModule.download(`${state.name}.json`, json);
    isDirty = false;
    _updateTitle();
  }

  function openProject(file) {
    const reader = new FileReader();
    reader.onload = e => {
      try {
        const loaded = JSON.parse(e.target.result);
        state = _migrateState(loaded);
        
        isDirty = false;
        
        // Restore image if present in JSON
        if (state.imageData) {
          const img = new Image();
          img.onload = () => {
            loadedImageSrc = state.imageData;
            CanvasModule.loadImage(img);
            $('#canvas-drop-hint').classList.add('hidden');
            $('#info-size').textContent = `${img.width}×${img.height}`;
            _renderSpriteList(); // Re-render to show thumbnails if needed
          };
          img.src = state.imageData;
        } else if (state.spritesheet) {
          // Old format: image was not embedded
          alert(`This project does not have the image embedded. Please load "${state.spritesheet}" manually and save the project to embed it.`);
        }

        _syncGridUI();
        _renderSpriteList();
        _renderAnimList();
        _renderMappingList();
        _updateInfoBar();
        _updateTitle();
        _autoSave();
        
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
        state.imageData = e.target.result; // Store for JSON
        state.spritesheet = file.name;
        CanvasModule.loadImage(img);
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
    const scale = parseFloat($('#insp-scale').value) || 1.0;

    // Check for existing sprite to update
    const currentId = InspectorModule.getCurrentSpriteId();
    let existing = state.sprites.find(s => s.id === currentId);
    
    // Fallback: check by blockIndex if it's a grid cell
    if (!existing && inspData.blockIndex !== -1) {
      existing = getSpriteByBlock(inspData.blockIndex);
    }

    if (existing) {
      existing.name = name;
      existing.region = { ...inspData.region };
      existing.pivot = pivot;
      existing.tags  = tags;
      existing.scale = scale;
      existing.collision = { ...inspData.collision };
    } else {
      state.sprites.push({
        id:         _uid(),
        name,
        blockIndex: inspData.blockIndex,
        frameIndex: inspData.frameIndex,
        region:     { ...inspData.region },
        pivot,
        tags,
        scale,
        collision:  { ...inspData.collision }
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

  function _renderMappingList() {
    const list = $('#fruit-mapping-list');
    if (!list) return;
    list.innerHTML = '';
    
    // Header & Add Button
    const header = document.createElement('div');
    header.className = 'section-header';
    header.style.padding = '0 0 10px 0';
    header.innerHTML = `<span>Registry</span> <button class="btn-full small" id="btn-add-fruit-slot">+ Add</button>`;
    list.appendChild(header);
    header.querySelector('#btn-add-fruit-slot').onclick = () => {
      const nextId = state.fruitMapping.length > 0 ? Math.max(...state.fruitMapping.map(f => parseInt(f.id)||0)) + 1 : 1;
      state.fruitMapping.push({ id: nextId, name: `Fruit ${nextId}`, sprite: "" });
      markDirty();
      _renderMappingList();
    };

    if (!state.fruitMapping || !Array.isArray(state.fruitMapping)) state.fruitMapping = [];

    state.fruitMapping.forEach((item, index) => {
      const row = document.createElement('div');
      row.className = 'mapping-row dynamic';
      
      const idInp = document.createElement('input');
      idInp.type = 'number';
      idInp.className = 'tier-id-inp';
      idInp.value = item.id;
      idInp.title = "Internal ID (used in Godot)";
      idInp.onchange = (e) => { item.id = parseInt(e.target.value); markDirty(); };
      row.appendChild(idInp);

      const nameInp = document.createElement('input');
      nameInp.type = 'text';
      nameInp.className = 'tier-name-inp';
      nameInp.value = item.name;
      nameInp.placeholder = "Fruit Name";
      nameInp.onchange = (e) => { item.name = e.target.value; markDirty(); };
      row.appendChild(nameInp);
      
      const sel = document.createElement('select');
      const optNone = document.createElement('option');
      optNone.value = ''; optNone.textContent = '— Sprite —';
      sel.appendChild(optNone);
      
      state.sprites.forEach(sp => {
        const opt = document.createElement('option');
        opt.value = sp.name;
        opt.textContent = sp.name;
        if (item.sprite === sp.name) opt.selected = true;
        sel.appendChild(opt);
      });
      
      sel.onchange = (e) => {
        item.sprite = e.target.value;
        markDirty();
      };
      row.appendChild(sel);

      const del = document.createElement('button');
      del.className = 'btn-icon small';
      del.textContent = '✕';
      del.onclick = () => {
        state.fruitMapping.splice(index, 1);
        markDirty();
        _renderMappingList();
      };
      row.appendChild(del);

      list.appendChild(row);
    });
  }

  function _renderSpriteList() {
    const list = $('#sprite-list');
    list.innerHTML = '';
    
    // Also refresh mapping list if it's visible
    if ($('#tab-mapping').style.display !== 'none') _renderMappingList();

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
        InspectorModule.showSprite(sp, CanvasModule.getImage());
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

  function _downloadExport(e) {
    if (e) e.preventDefault();
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
    CanvasModule.init($('#main-canvas'), {
      onCellSelect: (cell, img) => { /* inspector already updated inside module */ },
      onFreeSelect: (rect)      => { /* inspector already updated inside module */ }
    });

    // Timeline
    TimelineModule.init();
    
    // Inspector UI logic
    InspectorModule.initUI();

    // Toolbar buttons
    $('#btn-new').addEventListener('click', e => { e.preventDefault(); newProject(); });
    $('#btn-save').addEventListener('click', saveProject);
    $('#btn-open').addEventListener('click', e => { e.preventDefault(); $('#file-input-json').click(); });
    $('#btn-load-img').addEventListener('click', e => { e.preventDefault(); $('#file-input-img').click(); });
    $('#btn-export').addEventListener('click', e => { e.preventDefault(); openExportModal(); });

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

    // Panel Tabs (Right Sidebar)
    document.querySelectorAll('.panel-tab').forEach(tab => {
      tab.addEventListener('click', () => {
        const target = tab.dataset.tab;
        document.querySelectorAll('.panel-tab').forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        
        document.querySelectorAll('.panel-tab-content').forEach(c => c.style.display = 'none');
        $(`#tab-${target}`).style.display = 'block';
        
        if (target === 'mapping') _renderMappingList();
      });
    });

    _renderMappingList();

    // Adjustment Tools
    $('#tool-auto-fit').addEventListener('click', () => InspectorModule.autoFit());
    $('#tool-nudge-u').addEventListener('click',  () => InspectorModule.nudge(0, -1));
    $('#tool-nudge-d').addEventListener('click',  () => InspectorModule.nudge(0, 1));
    $('#tool-nudge-l').addEventListener('click',  () => InspectorModule.nudge(-1, 0));
    $('#tool-nudge-r').addEventListener('click',  () => InspectorModule.nudge(1, 0));
    $('#tool-nudge-ul').addEventListener('click', () => InspectorModule.nudge(-1, -1));
    $('#tool-nudge-ur').addEventListener('click', () => InspectorModule.nudge(1, -1));
    $('#tool-nudge-dl').addEventListener('click', () => InspectorModule.nudge(-1, 1));
    $('#tool-nudge-dr').addEventListener('click', () => InspectorModule.nudge(1, 1));

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
      
      // Nudge with arrows
      if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight'].includes(e.key)) {
        if (document.activeElement.tagName !== 'INPUT') {
          e.preventDefault();
          const dx = e.key === 'ArrowLeft' ? -1 : (e.key === 'ArrowRight' ? 1 : 0);
          const dy = e.key === 'ArrowUp' ? -1 : (e.key === 'ArrowDown' ? 1 : 0);
          const mult = e.shiftKey ? 5 : 1;
          InspectorModule.nudge(dx * mult, dy * mult);
        }
      }
    });

    _updateTitle();
    _syncGridUI();
    
    // Recovery
    _autoLoad();

    // Prevent accidental navigation
    window.onbeforeunload = (e) => {
      if (isDirty) {
        e.preventDefault();
        return (e.returnValue = 'You have unsaved changes. Are you sure you want to leave?');
      }
    };
  }

  const $ = sel => document.querySelector(sel);

  return {
    init, newProject, saveProject, openProject, loadImageFile,
    getGridState, getSprites, getAnimations,
    getSpriteById, getSpriteByBlock, markDirty, updateZoomDisplay
  };
})();

// ════════════════════════════════════════ BOOT ══
document.addEventListener('DOMContentLoaded', () => App.init());
