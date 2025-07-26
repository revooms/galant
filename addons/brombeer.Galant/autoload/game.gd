extends Node
class_name Game

var title: String = "Untitled Game"
var version: String = "0.1"
var author: String = "Unnamed Author"
var release_date: String = "2025-01-01" # Y-m-d

var is_ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setIsReady(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getPlayer() -> void:
	pass

func setIsReady(state: bool) -> void:
	is_ready = state

	if state == true:
		print("Game is ready")

