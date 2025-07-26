extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasModulate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_modulate.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
