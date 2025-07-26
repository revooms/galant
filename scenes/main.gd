extends Node2D

const fade_steps = 50.0
const fade_timer = 0.02

var tilemap_layer_ground
var mouse_debug_label

@export var world_scene: PackedScene
@onready var black_fade_screen: ColorRect = $UI/BlackFadeScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not world_scene:
		push_error("Fatal: 'important_path' wurde nicht gesetzt!")
		get_tree().quit() # Beendet das Spiel

	load_scene_async(world_scene.resource_path)
	tilemap_layer_ground = get_tree().get_first_node_in_group("tilemaplayers")
	mouse_debug_label = %MouseDebugLabel
	fadeIn()
	# await get_tree().create_timer(5).timeout
	# fadeOut()
	# loadScene()
	pass

func _process(_delta) -> void:
	# Handle mouse cursor
	if Engine.is_editor_hint():
		return # nicht im Editor ausführen

	debugMouseTile()

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

func getMouseOverTile() -> Vector2i:
	var world_pos = get_global_mouse_position()
	var tile_coords: Vector2i
	if tilemap_layer_ground:
		var local_pos = tilemap_layer_ground.to_local(world_pos)
		tile_coords = tilemap_layer_ground.local_to_map(local_pos)

	return tile_coords

func debugMouseTile() -> void:
	var mt = getMouseOverTile()
	var msg := "Mouse Tile:"
	if tilemap_layer_ground:
		var tile = tilemap_layer_ground.get_cell_tile_data(mt)
		if tile:
			msg += "\nMouseTile: [b]%d/%d[/b]" % [mt.x, mt.y]
			msg += "\nTileData:  [b]%s[/b]" % [str(tile)]
		mouse_debug_label.text = msg

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
