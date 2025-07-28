@tool
extends Node2D

@onready var sound_flashlight_on: AudioStream = preload("res://assets/audio/fx/flashlight_on.ogg")
@onready var sound_flashlight_off: AudioStream = preload("res://assets/audio/fx/flashlight_off.ogg")
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var ambient_light: PointLight2D = $AmbientLight
@onready var ambient_light_shadow: PointLight2D = $AmbientLightShadow
@onready var flash_light: PointLight2D = $FlashLight
@onready var flash_light_shadow: PointLight2D = $FlashLightShadow

@export var flashlight_energy: float = 1.0
@export var flashlight_color: Color = Color.WHITE_SMOKE
@export var flashlight_texture: Texture2D

@export var ambientlight_energy: float = 0.7
@export var ambientlight_color: Color = Color.WHITE_SMOKE
@export var ambientlight_texture: Texture2D

@export var shadow_energy: float = 0.4
@export var shadow_color: Color = Color.WHEAT

var is_on: bool = false

var _last_flashlight_energy = flashlight_energy
var _last_flashlight_color = flashlight_color
var _last_flashlight_texture = flashlight_texture
var _last_ambientlight_energy = ambientlight_energy
var _last_ambientlight_color = ambientlight_color
var _last_ambientlight_texture = ambientlight_texture
var _last_shadow_energy = shadow_energy
var _last_shadow_color = shadow_color


func toggleOnOff() -> void:
	is_on = !is_on
	if is_on == true:
		self.enable()
	else:
		self.disable()
	_playsound(is_on)

func _playsound(mode: bool) -> void:
	audio_stream_player_2d.stream = sound_flashlight_on if mode else sound_flashlight_off
	audio_stream_player_2d.play()

func _set_flashlight_energy(newval) ->void:
	flashlight_energy = newval
	flash_light.energy = newval

func _set_flashlight_color(newval) ->void:
	flashlight_color = newval
	flash_light.color = newval

func _set_flashlight_texture(newval) ->void:
	flashlight_texture = newval
	flash_light.texture = newval

func _set_ambientlight_energy(newval) ->void:
	ambientlight_energy = newval
	ambient_light.energy = newval

func _set_ambientlight_color(newval) ->void:
	ambientlight_color = newval
	ambient_light.color = newval

func _set_ambientlight_texture(newval) ->void:
	ambientlight_texture = newval
	ambient_light.texture = newval

func _set_shadow_energy(newval) ->void:
	shadow_energy = newval
	# ambient_light_shadow.energy = newval
	flash_light_shadow.energy = newval

func _set_shadow_color(newval) ->void:
	shadow_color = newval
	# ambient_light.color = newval
	flash_light_shadow.color = newval


func _on_flashlight_toggled() -> void:
	toggleOnOff()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GalantEventHub.player_flashlight_toggled.connect(_on_flashlight_toggled)
	setAll()
	if is_on == true:
		self.enable()
	else:
		self.disable()

func setAll() -> void:
	_set_flashlight_energy(flashlight_energy)
	_set_flashlight_color(flashlight_color)
	_set_flashlight_texture(flashlight_texture)
	_set_ambientlight_energy(ambientlight_energy)
	_set_ambientlight_color(ambientlight_color)
	_set_ambientlight_texture(ambientlight_texture)
	_set_shadow_energy(shadow_energy)
	_set_shadow_color(shadow_color)


func enable() -> void:
	# GalantDebugger.line(self, "flashlight enabled")
	for ch in get_tree().get_nodes_in_group("flashlight"):
		ch.enabled = true

func disable() -> void:
	# GalantDebugger.line(self, "flashlight disabled")
	for ch in get_tree().get_nodes_in_group("flashlight"):
		ch.enabled = false

func _process(_delta):
	# wird nur im Editor ausgeführt, wenn sich etwas ändert
	if Engine.is_editor_hint():
		_check_for_changes()

func _check_for_changes():
	if flashlight_energy != _last_flashlight_energy:
		_last_flashlight_energy = flashlight_energy
		_set_flashlight_energy(_last_flashlight_energy)
	if flashlight_color != _last_flashlight_color:
		_last_flashlight_color = flashlight_color
		_set_flashlight_color(_last_flashlight_color)
	if flashlight_texture != _last_flashlight_texture:
		_last_flashlight_texture = flashlight_texture
		_set_flashlight_texture(_last_flashlight_texture)
	if ambientlight_energy != _last_ambientlight_energy:
		_last_ambientlight_energy = ambientlight_energy
		_set_ambientlight_energy(_last_ambientlight_energy)
	if ambientlight_color != _last_ambientlight_color:
		_last_ambientlight_color = ambientlight_color
		_set_ambientlight_color(_last_ambientlight_color)
	if ambientlight_texture != _last_ambientlight_texture:
		_last_ambientlight_texture = ambientlight_texture
		_set_ambientlight_texture(_last_ambientlight_texture)
	if shadow_energy != _last_shadow_energy:
		_last_shadow_energy = shadow_energy
		_set_shadow_energy(_last_shadow_energy)
	if shadow_color != _last_shadow_color:
		_last_shadow_color = shadow_color
		_set_shadow_color(_last_shadow_color)
