@tool
extends EditorPlugin

# Replace this value with a PascalCase autoload name, as per the GDScript style guide.
const ROOT_PATH = "res://addons/brombeer.Galant"
const AUTOLOAD_PATH = ROOT_PATH + "/autoload"
const AUTOLOAD_NAME_GAME = "BrombeerGame"
const AUTOLOAD_NAME_EVENTHUB = "BrombeerEventHub"
const AUTOLOAD_NAME_DEBUGGLER = "BrombeerDebuggler"
# const AUTOLOAD_NAME_AUDIOMANAGER = "BrombeerAudioManager"

var autoloads = [
	{
		"name": AUTOLOAD_NAME_GAME,
		"autoload": AUTOLOAD_PATH + "/game.gd",
	},
	{
		"name": AUTOLOAD_NAME_EVENTHUB,
		"autoload": AUTOLOAD_PATH + "/eventhub.gd",
	},
	# {
	# 	"name": AUTOLOAD_NAME_AUDIOMANAGER,
	# 	"autoload": AUTOLOAD_PATH + "/audiomanager.gd",
	# },
	{
		"name": AUTOLOAD_NAME_DEBUGGLER,
		"autoload": AUTOLOAD_PATH + "/debuggler.gd",
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
