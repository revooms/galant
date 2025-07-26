@tool
extends EditorPlugin

# Replace this value with a PascalCase autoload name, as per the GDScript style guide.
const ROOT_PATH = "res://addons/brombeer.Galant"
const AUTOLOAD_NAME_GAME = "BrombeerGame"
const AUTOLOAD_NAME_EVENTHUB = "BrombeerEventHub"

var autoloads = [
	{
		"name": AUTOLOAD_NAME_GAME,
		"autoload": "res://addons/brombeer.Galant/autoload/game.gd",
	},
	{
		"name": AUTOLOAD_NAME_EVENTHUB,
		"autoload": "res://addons/brombeer.Galant/autoload/eventhub.gd",
	},
]

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass

func _enable_plugin():
	# The autoload can be a scene or script file.
	for i in autoloads:
		add_autoload_singleton(i.name, i.autoload)

func _disable_plugin():
	for i in autoloads:
		remove_autoload_singleton(i.name)
