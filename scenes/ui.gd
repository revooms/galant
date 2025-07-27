extends CanvasLayer

enum Panels {
	TOPLEFT = 0,
	TOPRIGHT = 1,
	BOTTOMLEFT = 2,
	BOTTOMRIGHT = 3
}

@export var panels: Array[Control]
@export var contents: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	# Handle mouse cursor
	if Engine.is_editor_hint():
		return # nicht im Editor ausführen

func output(_panel: Panels, msg: String) -> void:
	contents[_panel].append(msg)
	pass
