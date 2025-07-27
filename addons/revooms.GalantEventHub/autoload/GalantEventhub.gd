extends Node

signal exitrequested
signal maingameready

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func trigger(signalName: String) -> void:
	emit_signal(signalName)
	GalantDebugger.line(self, "Signal emitted: %s" % [signalName])
