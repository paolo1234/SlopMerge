/**
 * timeline.js — Animation timeline & preview
 */

const TimelineModule = (() => {
  let currentAnim = null;
  let isPlaying = false;
  let currentFrame = 0;
  let animInterval = null;
  let previewCtx = null;

  const $ = id => document.getElementById(id);

  function init() {
    previewCtx = $('anim-preview-canvas').getContext('2d');
    $('tl-play').addEventListener('click', play);
    $('tl-stop').addEventListener('click', stop);
    $('tl-prev').addEventListener('click', prevFrame);
    $('tl-next').addEventListener('click', nextFrame);
    $('btn-close-preview').addEventListener('click', () => {
      $('anim-preview-overlay').style.display = 'none';
      stop();
    });
    $('btn-preview-anim').addEventListener('click', () => {
      if (!currentAnim) return;
      $('anim-preview-overlay').style.display = '';
      play();
    });
  }

  function selectAnim(anim) {
    stop();
    currentAnim = anim;
    currentFrame = 0;
    render();
    $('tl-fps-display').textContent = anim ? `${anim.fps} fps` : '— fps';
    $('tl-frame-display').textContent = `frame 0/${anim ? anim.frames.length : 0}`;

    if (anim) {
      $('anim-inspector-section').style.display = '';
      $('anim-insp-title').textContent = `ANIMATION: ${anim.name}`;
      $('anim-fps').value  = anim.fps;
      $('anim-loop').checked = anim.loop;
      renderFrameList(anim);
    } else {
      $('anim-inspector-section').style.display = 'none';
    }
  }

  function render() {
    const track = $('timeline-frames');
    track.innerHTML = '';
    if (!currentAnim || currentAnim.frames.length === 0) {
      track.innerHTML = '<div class="tl-empty">No frames — add sprites from the inspector</div>';
      return;
    }
    currentAnim.frames.forEach((f, i) => {
      const sprite = App.getSpriteById(f.sprite_id);
      const div = document.createElement('div');
      div.className = 'tl-frame' + (i === currentFrame ? ' active' : '');
      const thumb = _makeThumb(sprite, 72);
      div.appendChild(thumb);
      const label = document.createElement('div');
      label.className = 'tl-frame-label';
      label.textContent = `f${i}`;
      div.appendChild(label);
      div.addEventListener('click', () => { currentFrame = i; render(); _drawPreview(i); });
      track.appendChild(div);
    });
    $('tl-frame-display').textContent = `frame ${currentFrame}/${currentAnim.frames.length}`;
  }

  function renderFrameList(anim) {
    const list = $('anim-frames-list');
    list.innerHTML = '';
    if (!anim) return;
    anim.frames.forEach((f, i) => {
      const sprite = App.getSpriteById(f.sprite_id);
      const item = document.createElement('div');
      item.className = 'frame-item';

      const thumb = _makeThumb(sprite, 24);
      item.appendChild(thumb);

      const name = document.createElement('span');
      name.textContent = sprite ? `${sprite.name} [${f.sub_index ?? 0}]` : `(deleted) id:${f.sprite_id}`;
      item.appendChild(name);

      const del = document.createElement('span');
      del.className = 'frame-del';
      del.textContent = '✕';
      del.addEventListener('click', () => {
        anim.frames.splice(i, 1);
        renderFrameList(anim);
        render();
        App.markDirty();
      });
      item.appendChild(del);

      list.appendChild(item);
    });
  }

  function _makeThumb(sprite, size) {
    const c = document.createElement('canvas');
    c.width = size; c.height = size;
    c.className = 'frame-thumb';
    const tc = c.getContext('2d');
    const img = CanvasModule.getImage();
    if (sprite && img) {
      tc.imageSmoothingEnabled = false;
      tc.drawImage(img,
        sprite.region.x, sprite.region.y, sprite.region.w, sprite.region.h,
        0, 0, size, size
      );
    }
    return c;
  }

  function _drawPreview(frameIdx) {
    const c = $('anim-preview-canvas');
    const pCtx = previewCtx;
    pCtx.clearRect(0, 0, c.width, c.height);
    // Checker
    for (let cy = 0; cy < c.height; cy += 10) {
      for (let cx = 0; cx < c.width; cx += 10) {
        pCtx.fillStyle = ((cx / 10 + cy / 10) % 2 === 0) ? '#1c2128' : '#161b22';
        pCtx.fillRect(cx, cy, 10, 10);
      }
    }
    if (!currentAnim || currentAnim.frames.length === 0) return;
    const f = currentAnim.frames[frameIdx % currentAnim.frames.length];
    const sprite = App.getSpriteById(f.sprite_id);
    const img = CanvasModule.getImage();
    if (sprite && img) {
      pCtx.imageSmoothingEnabled = false;
      pCtx.drawImage(img,
        sprite.region.x, sprite.region.y, sprite.region.w, sprite.region.h,
        0, 0, c.width, c.height
      );
    }
  }

  function play() {
    if (!currentAnim || currentAnim.frames.length === 0) return;
    stop();
    const ms = 1000 / (currentAnim.fps || 8);
    isPlaying = true;
    animInterval = setInterval(() => {
      currentFrame = (currentFrame + 1) % currentAnim.frames.length;
      if (!currentAnim.loop && currentFrame === 0) { stop(); return; }
      render();
      _drawPreview(currentFrame);
    }, ms);
    $('tl-play').textContent = '⏸';
  }

  function stop() {
    clearInterval(animInterval);
    isPlaying = false;
    $('tl-play').textContent = '▶';
  }

  function prevFrame() {
    if (!currentAnim) return;
    currentFrame = (currentFrame - 1 + currentAnim.frames.length) % currentAnim.frames.length;
    render(); _drawPreview(currentFrame);
  }

  function nextFrame() {
    if (!currentAnim) return;
    currentFrame = (currentFrame + 1) % currentAnim.frames.length;
    render(); _drawPreview(currentFrame);
  }

  function getCurrentAnim() { return currentAnim; }

  return { init, selectAnim, render, renderFrameList, getCurrentAnim };
})();
