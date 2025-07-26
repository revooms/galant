extends Node2D

@export var player_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var p = player_scene.instantiate()
	p.position = self.position
	self.add_child(p)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
