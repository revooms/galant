extends Node

enum PANELS{
	TOPLEFT,
	TOPRIGHT,
	BOTTOMLEFT,
	BOTTOMRIGHT,
}

@onready var debugpanels_scene : PackedScene = preload("res://addons/revooms.GalantDebugger/scenes/debug_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Debugger ready")
	var _root = get_tree().root
	if not _root.get_node_or_null("DebugUI"):
		var DebugUILayer = debugpanels_scene.instantiate()
		DebugUILayer.name = "DebugUI"
		_root.add_child.call_deferred(DebugUILayer)
		DebugUILayer.set_layer(0)  # Layer-Index (0 = oberste Ebene)

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

func out(issuer: Node, message: String, panelid: PANELS):
	# ??? geht das nicht anders/besser?
	var panel_name
	if panelid == 0:
		panel_name = "DebugUI/PanelTopLeft"
	elif panelid == 1:
		panel_name = "DebugUI/PanelTopRight"
	elif panelid == 2:
		panel_name = "DebugUI/PanelBottomLeft"
	elif panelid == 3:
		panel_name = "DebugUI/PanelBottomRight"

	var outputlabel = get_tree().root.get_node(panel_name).find_child("RichTextLabel")
	outputlabel.text = message
	pass
