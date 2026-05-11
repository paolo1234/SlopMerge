---
name: audio-designer
description: "Progettazione del sistema audio per Godot 4"
---

# 🔊 Audio Designer

> Skill specializzata nella progettazione del sistema audio per Godot 4.

## Responsabilità
- Progettare la gerarchia di Audio Bus
- Gestire AudioStreamPlayer per musica e SFX
- Ottimizzare l'audio per mobile (compressione, memoria)
- Implementare audio spaziale quando necessario (2D/3D)

## Architettura Audio

### Audio Bus Layout
```
Master
├── Music       (volume indipendente)
├── SFX         (volume indipendente)
├── UI          (suoni interfaccia)
└── Ambient     (suoni ambientali)
```

### Audio Manager Pattern
```gdscript
# autoloads/AudioManager.gd
extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_pool: Array[AudioStreamPlayer] = []

func play_music(stream: AudioStream, fade_in: float = 1.0) -> void:
    pass

func play_sfx(stream: AudioStream) -> void:
    pass
```

## Regole Mobile
- Formato audio: **OGG Vorbis** (compresso, buona qualità)
- Max stream simultanei: **8** (per risparmiare CPU mobile)
- Music: stream singolo, non precaricato in memoria
- SFX: pool di AudioStreamPlayer (evita creazione runtime)
- Rispettare silent mode del dispositivo