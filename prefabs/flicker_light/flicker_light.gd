@tool
extends Node

@export var color: Color = Color.WHITE_SMOKE
@export var frequency: float = 1.5
@export var use_shadow: bool = false
@export_range(0.5, 4.0) var intensity: float = 2.0

func _set_shadow(state: bool) -> void:
	use_shadow = state
	self.get_child(0).shadow_enabled = use_shadow

func _set_color(newcolor: Color):
	color = newcolor
	self.get_child(0).color = color

func _set_intensity(newintensity: float) -> void:
	intensity = newintensity
	self.get_child(0).energy = intensity

func _ready() -> void:
	_set_color(color)
	_set_shadow(use_shadow)


func _process(_delta):
	# wird nur im Editor ausgeführt, wenn sich etwas ändert
	if Engine.is_editor_hint():
		_check_for_changes()

var __last_color := color
var __last_shadow := use_shadow
var __last_intensity: float = intensity

func _check_for_changes():
	if intensity != __last_intensity:
		__last_intensity = intensity
		_set_intensity(__last_intensity)
		
	if use_shadow != __last_shadow:
		__last_shadow = use_shadow
		_set_shadow(__last_shadow)

	if color != __last_color:
		__last_color = color
		_set_color(__last_color)