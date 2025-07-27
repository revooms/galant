@tool
extends Node

@export var color: Color = Color.WHITE_SMOKE
@export var texture_scale: float = 1.0
@export_range(0.25, 3.0) var intensity: float = 0.7
@export_range(0.1, 1) var shadowintensity: float = 0.2

@export_group("Flicker")
@export var frequency: float = 1.5
@export var curve: Curve

func _set_shadowintensity(newshadowintensity: float) -> void:
	shadowintensity = newshadowintensity
	self.get_child(1).energy = newshadowintensity

func _set_color(newcolor: Color):
	color = newcolor
	self.get_child(0).color = color
	self.get_child(1).color = color

func _set_intensity(newintensity: float) -> void:
	intensity = newintensity
	self.get_child(0).energy = intensity

func _set_scale(newscale: float) -> void:
	texture_scale = newscale
	self.get_child(0).texture_scale = texture_scale
	self.get_child(1).texture_scale = texture_scale

func _ready() -> void:
	_set_color(color)
	_set_shadowintensity(shadowintensity)
	_set_scale(texture_scale)
	_set_intensity(intensity)

func enable() -> void:
	for ch in get_children():
		ch.enabled = true

func disable() -> void:
	for ch in get_children():
		ch.enabled = false

func _process(_delta):
	# wird nur im Editor ausgeführt, wenn sich etwas ändert
	if Engine.is_editor_hint():
		_check_for_changes()

var __last_color := color
var __last_intensity: float = intensity
var __last_scale: float = texture_scale
var __last_shadowintensity:= shadowintensity

func _check_for_changes():
	if texture_scale != __last_scale:
		__last_scale = texture_scale
		_set_scale(__last_scale)

	if intensity != __last_intensity:
		__last_intensity = intensity
		_set_intensity(__last_intensity)

	if shadowintensity != __last_shadowintensity:
		__last_shadowintensity = shadowintensity
		_set_shadowintensity(__last_shadowintensity)

	if color != __last_color:
		__last_color = color
		_set_color(__last_color)
