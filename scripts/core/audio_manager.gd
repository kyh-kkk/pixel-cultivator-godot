class_name AudioManager
extends Node
## 音频管理 —— BGM 与 SFX 双通道，支持音量持久化。

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var music_volume: float = -6.0
var sfx_volume: float = -3.0

# 音频注册表：实际项目把音频文件丢进 assets/audio/ 后在这里登记即可
var _music_lib := {}  # name -> AudioStream
var _sfx_lib := {}    # name -> AudioStream

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Master"
	add_child(music_player)
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "Master"
	add_child(sfx_player)
	EventBus.music_requested.connect(play_music)
	EventBus.sfx_requested.connect(play_sfx)

func register_music(name: String, stream: AudioStream) -> void:
	_music_lib[name] = stream

func register_sfx(name: String, stream: AudioStream) -> void:
	_sfx_lib[name] = stream

func play_music(name: String) -> void:
	if _music_lib.has(name):
		music_player.stream = _music_lib[name]
		music_player.volume_db = music_volume
		music_player.play()

func play_sfx(name: String, vol_db: float = 0.0) -> void:
	if _sfx_lib.has(name):
		sfx_player.stream = _sfx_lib[name]
		sfx_player.volume_db = sfx_volume + vol_db
		sfx_player.play()

func set_music_volume(db: float) -> void:
	music_volume = db
	if music_player.playing:
		music_player.volume_db = db

func set_sfx_volume(db: float) -> void:
	sfx_volume = db
