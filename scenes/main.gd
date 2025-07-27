extends Node2D

const fade_steps = 50.0
const fade_timer = 0.02

var tilemap_layer_ground
var mouse_debug_label

@export var world_scene: PackedScene

@onready var black_fade_screen: ColorRect = $UI/BlackFadeScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GalantEventHub.trigger("maingameready")
	if not world_scene:
		push_error("Fatal: 'important_path' wurde nicht gesetzt!")
		get_tree().quit() # Beendet das Spiel

	load_scene_async(world_scene.resource_path)
	fadeIn()
	# await get_tree().create_timer(5).timeout
	# fadeOut()
	# loadScene()
	pass

func load_scene_async(path: String) -> void:
	var _loader := ResourceLoader.load_threaded_request(path)
	while ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
	var scene := ResourceLoader.load_threaded_get(path)
	if scene:
		var inst = scene.instantiate()
		var world = get_node("World")
		inst.position = world.position
		world.add_child(inst)
		print("Scene loaded: %s" % path)

func fadeIn() -> void:
	# Von Alpha 1.0 → 0.0 (sichtbar → unsichtbar)
	for i in range(fade_steps, -1, -1):
		black_fade_screen.color.a = i / fade_steps
		await get_tree().create_timer(fade_timer).timeout

	black_fade_screen.visible = false

func fadeOut() -> void:
	black_fade_screen.visible = true
	# Von Alpha 0.0 → 1.0 (unsichtbar → schwarz)
	for i in range(0, fade_steps + 1):
		black_fade_screen.color.a = i / fade_steps
		await get_tree().create_timer(fade_timer).timeout

func showMovementHelp() -> void:
	var _msg = "Help: "
	var mapname
	var key_string

	var movements: Array
	for mode in ["up", "down", "left", "right"]:
		key_string = Galant.getInputEventKey(mode)
		movements.append(key_string)

	_msg += "Move: %s" % [",".join(movements)]

	mapname = "toggle_light"
	key_string = Galant.getInputEventKey(mapname)
	_msg += "%s: %s" % [mapname, key_string]

	mapname = "jump"
	key_string = Galant.getInputEventKey(mapname)
	_msg += "%s: %s" % [mapname, key_string]

	mapname = "crouch"
	key_string = Galant.getInputEventKey(mapname)
	_msg += "%s: %s" % [mapname, key_string]

	mapname = "sprint"
	key_string = Galant.getInputEventKey(mapname)
	_msg += "%s: %s" % [mapname, key_string]

	pass
