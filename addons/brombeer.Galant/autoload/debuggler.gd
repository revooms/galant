extends Node
class_name Debuggler

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

static func assembleMessage(msg: String) -> String:
	var formatted_message = "%s: %s" % [Game.getDate(), msg]
	return formatted_message


static func line(msg: String) -> void:
	print(assembleMessage(msg))
