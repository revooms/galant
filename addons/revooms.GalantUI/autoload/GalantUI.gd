extends Node
# class_name GalantUI

func _ready() -> void:
	print("UI ready")
	var _root = get_tree().root
	if not _root.get_node_or_null("UI"):
		var UILayer = CanvasLayer.new()
		UILayer.name = "UI"
		_root.add_child.call_deferred(UILayer)
		UILayer.set_layer(0)

