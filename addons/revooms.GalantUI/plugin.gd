@tool
extends GalantEditorPlugin

# Test

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass

func _disable_plugin():
	super._disable_plugin()

func _enable_plugin():
	super._enable_plugin()
