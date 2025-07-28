extends CharacterBody2D
class_name Player

@export var disable_on_ready: Array[ Node ]

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const JETPACK_VELOCITY = -200.0
const MAX_JUMPS = 2

var is_falling: bool = false
var is_idle: bool = true
var is_moving: bool = false
var direction: int = 1
var number_of_jumps = 0
var tilemap_layer_ground
var input_direction
var face_direction = 1 # 1 = right, -1 = left
var mouse_cursor_side = 0 # 1 = right, -1 = left

var _use_arm_clamping: bool = false

@onready var jetpack_audio_stream_player_2d: AudioStreamPlayer2D = $PlayerBody/Jetpack/AudioStreamPlayer2D
@onready var left_arm_pivot: Node2D = $PlayerBody/LeftArmPivot

func _ready() -> void:
	for n in disable_on_ready:
		if n.has_method("hide"):
			n.hide()

	tilemap_layer_ground = get_tree().get_first_node_in_group("tilemaplayers")

func _process(_delta) -> void:
	if Engine.is_editor_hint():
		return # nicht im Editor ausführen
	debug()

func _physics_process(delta: float) -> void:
	if is_on_floor():
		is_falling = false
		number_of_jumps = 0

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y > 0:
			is_falling = true

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if number_of_jumps < MAX_JUMPS:
			velocity.y = JUMP_VELOCITY
			number_of_jumps += 1

	# Handle jetpack
	if Input.is_action_pressed("secondary_action"):
		%PlayerBody.get_child(0).get_node("GPUParticles2D").emitting = true
		%PlayerBody.get_child(0).get_node("Light").enable()
		velocity.y = lerpf(velocity.y, JETPACK_VELOCITY, delta * 0.001 + 0.2)
		jetpack_audio_stream_player_2d.play()
	else:
		%PlayerBody.get_child(0).get_node("GPUParticles2D").emitting = false
		%PlayerBody.get_child(0).get_node("Light").disable()
		jetpack_audio_stream_player_2d.stop()

	# Handle mouse cursor side
	mouse_cursor_side = clamp(get_local_mouse_position().x, -1,1)

	# Handle light
	if Input.is_action_just_pressed("toggle_light"):
		GalantEventHub.trigger("player_flashlight_toggled")

	# Get the input direction and handle the movement/deceleration.
	input_direction = Input.get_axis("left", "right")
	if input_direction:
		face_direction = input_direction
		velocity.x = input_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	left_arm_pivot.look_at(get_global_mouse_position())
	if _use_arm_clamping:
		# if face_direction == -1:
		# 	left_arm_pivot.rotation_degrees = clampf(left_arm_pivot.rotation_degrees, -270, -90)
		# else:
		# 	left_arm_pivot.rotation_degrees = clampf(left_arm_pivot.rotation_degrees, -90, 90)
		pass

	# Handle idle/moving
	is_idle = is_on_floor() && (velocity.x == 0)
	is_moving = not is_idle

	handleFlippingByDirection(face_direction)

	move_and_slide()

func getIsIdle() -> bool:
	return is_idle

func getIsMoving() -> bool:
	return not is_idle

func handleFlippingByDirection(inputdirection) -> void:
	if mouse_cursor_side == face_direction:
		if inputdirection > 0:
			%PlayerHead.flip_h = true
			%PlayerBody.flip_h = true
			%PlayerBody.get_child(0).flip_h = true
			%PlayerBody.get_child(0).position = Vector2(-64, -12)
			%PlayerBody.get_child(0).rotation = 0.1
		elif inputdirection < 0:
			%PlayerHead.flip_h = false
			%PlayerBody.flip_h = false
			%PlayerBody.get_child(0).flip_h = false
			%PlayerBody.get_child(0).position = Vector2(64, -12)
			%PlayerBody.get_child(0).rotation = -0.1


func getPositionOnTileMapLayer(player: Player, layer: TileMapLayer) -> Vector2i:
	var grid_position_adjust = Vector2i(0, 1)
	var tile_coords: Vector2 = layer.local_to_map(layer.to_local(player.global_position))+ grid_position_adjust
	return tile_coords

func debug() -> void:
	var position_on_tilemaplayer := self.getPositionOnTileMapLayer(self, tilemap_layer_ground)
	var msg := "Player Debug:"
	msg += "\nPos:    [b]%d/%d[/b]" % [self.position.x, self.position.y]
	msg += "\nGRID:   [b]%d/%d[/b]" % [position_on_tilemaplayer.x, position_on_tilemaplayer.y]
	msg += "\nVel:    [b]%d/%d[/b]" % [self.velocity.x, self.velocity.y]
	msg += "\nIsMoving:[b]%s[/b]" % [str(getIsMoving())]
	msg += "\nIsIdle: [b]%s[/b]" % [str(getIsIdle())]
	msg += "\nDir:    [b]%d - %d[/b]" % [input_direction, face_direction]
	msg += "\nArmRot: [b]%d[/b]" % [left_arm_pivot.rotation_degrees]
	msg += "\nMouse:  [b]%d[/b]" % [mouse_cursor_side]
	msg += "\nJumps:  [b]%d/%d[/b]" % [self.number_of_jumps, MAX_JUMPS]
	msg += "\nIsOnFloor: [b]%s[/b]" % [str(is_on_floor())]
	msg += "\nIsOnWall: [b]%s[/b]" % [str(is_on_wall())]
	msg += "\nIsOnceiling: [b]%s[/b]" % [str(is_on_ceiling())]
	msg += "\nIsFalling: [b]%s[/b]" % [str(is_falling)]
	# msg += "\nLight: [b]%s[/b]" % str(is_light_on)
	GalantDebugger.out(self, msg, GalantDebugger.PANELS.TOPRIGHT)
