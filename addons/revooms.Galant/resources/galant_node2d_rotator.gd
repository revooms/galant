extends Node2D
class_name GalantNode2DRotator

@export_range(0.01, 0.2) var speed: float = 0.1
@export var rotate_clockwise: bool = true

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	var parentEle = get_parent()
	var rotationSpeed = speed
	if not rotate_clockwise:
		rotationSpeed = -rotationSpeed

	parentEle.rotate(rotationSpeed)
