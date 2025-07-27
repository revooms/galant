extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var tile_highlighter: Sprite2D = $TileHighlighter
@onready var directional_light_2d: DirectionalLight2D = $DirectionalLight2D
@onready var parallax_tile_map_layers_test: Node2D = $ParallaxTileMapLayersTest

@export var show_directional_light: bool = false
@export var show_canvasmodulate: bool = true
@export var show_parallax: bool = true

var tilemap
var mouse_debug_label
const LAYER := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_modulate.visible = show_canvasmodulate
	directional_light_2d.visible = show_directional_light
	parallax_tile_map_layers_test.visible = show_parallax

	tilemap = get_tree().get_first_node_in_group("tilemaplayers")
	var tree = get_tree()
	mouse_debug_label = tree.get("UI/DEBUGPANELS/PanelTopLeft/MarginContainer/Panel/MarginContainer/RichTextLabel")
	print(tree)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	# Handle mouse cursor
	if Engine.is_editor_hint():
		return # nicht im Editor ausführen

	# debugMouseTile()

func getMouseOverTile() -> Vector2i:
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_2d()
	if camera == null:
		tile_highlighter.visible = false
		return Vector2i.ZERO

	# Mausposition im Welt-Koordinatenraum:
	var mouse_world = camera.get_global_transform().affine_inverse() * mouse_pos

	# Mausposition lokal zum TileMapLayer:
	var local_pos = tilemap.to_local(mouse_world)
	var tile_coords = tilemap.local_to_map(local_pos)

	# Tile prüfen:
	var tile_data = tilemap.get_cell_tile_data(tile_coords)
	if tile_data != null:
		var cell_pos = tilemap.map_to_local(tile_coords)
		tile_highlighter.global_position = tilemap.to_global(cell_pos + tilemap.cell_size / 2)
		tile_highlighter.visible = true
	else:
		tile_highlighter.visible = false

	highlightTile(tile_coords)

	return tile_coords

func debugMouseTile() -> void:
	var mt = getMouseOverTile()
	var msg := "Mouse Tile:"
	if tilemap:
		var tile = tilemap.get_cell_tile_data(mt)
		if tile:
			msg += "\nMouseTile: [b]%d/%d[/b]" % [mt.x, mt.y]
			msg += "\nTileData:  [b]%s[/b]" % [str(tile)]
		mouse_debug_label.text = msg

func highlightTile(coords: Vector2i) -> void:
	tile_highlighter.position = coords
	tile_highlighter.visible = true
