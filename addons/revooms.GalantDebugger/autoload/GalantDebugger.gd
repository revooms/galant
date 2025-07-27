extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _assembleMessage(issuer:String, msg: String) -> String:
	var formatted_message = "%s %s: %s" % [Galant.getDate(), issuer, msg]
	return formatted_message

func _output() -> void:
	pass

func line(issuer: Node, msg: String) -> void:
	print(_assembleMessage(str(issuer), msg))
