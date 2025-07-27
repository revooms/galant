extends Node
class_name Game

var title: String = "Galant"
var version: String = "0.2"
var author: String = "brombeer"
var release_date: String = "2025-07-01" # Y-m-d

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

static func getInputEventKey(mapname: String) -> String:
	# Beispiel: Holt die erste Taste, die der Aktion "ui_accept" zugewiesen ist
	var events = InputMap.action_get_events(mapname)
	var key_string
	for event in events:
		if event is InputEventKey:
			var keycode = event.physical_keycode
			key_string = OS.get_keycode_string(keycode)

	return key_string

static func getDate() -> String:
	var current_date = Time.get_date_string_from_system()
	var formatted_date = current_date.format("%Y%m%d")
	return formatted_date
