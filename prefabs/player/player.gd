extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const JETPACK_VELOCITY = -200.0
const MAX_JUMPS = 2

var is_falling: bool = false
var is_light_on: bool = false
var direction: int = 1
var number_of_jumps = 0
var tilemap_layer_ground

@onready var light := $Light
@onready var AudioManager = $"/root/Main/AudioManager"

func _ready() -> void:
	tilemap_layer_ground = get_tree().get_first_node_in_group("tilemaplayers")
	setLight(false)

func setLight(state: bool) -> void:
	is_light_on = state
	if is_light_on == true:
		AudioManager.play_sound('player_flashlight', "res://assets/audio/fx/flashlight_on.ogg")
		light.enable()
	else:
		AudioManager.play_sound('player_flashlight', "res://assets/audio/fx/flashlight_off.ogg")
		light.disable()

func toggleLight() -> void:
	setLight(!is_light_on)

func _process(_delta) -> void:
	# Handle mouse cursor
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
		# %PlayerBody.get_child(0).get_node("AudioStreamPlayer2D").emitting = true
		%PlayerBody.get_child(0).get_node("Light").enable()
		velocity.y = lerpf(velocity.y, JETPACK_VELOCITY, delta * 0.001 + 0.2)
	else:
		%PlayerBody.get_child(0).get_node("GPUParticles2D").emitting = false
		# %PlayerBody.get_child(0).get_node("AudioStreamPlayer2D").emitting = false
		%PlayerBody.get_child(0).get_node("Light").disable()

	# Handle light
	if Input.is_action_just_pressed("toggle_light"):
		toggleLight()

	# Get the input direction and handle the movement/deceleration.
	var input_direction := Input.get_axis("left", "right")
	if input_direction:
		velocity.x = input_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if input_direction < 0:
		%PlayerHead.flip_h = false
		%PlayerBody.flip_h = false
		%PlayerBody.get_child(0).flip_h = false
		%PlayerBody.get_child(0).position = Vector2(64, -12)
		%PlayerBody.get_child(0).rotation = -0.1
	elif input_direction > 0:
		%PlayerHead.flip_h = true
		%PlayerBody.flip_h = true
		%PlayerBody.get_child(0).flip_h = true
		%PlayerBody.get_child(0).position = Vector2(-64, -12)
		%PlayerBody.get_child(0).rotation = 0.1

	move_and_slide()

func getPositionOnTileMapLayer(player: Player, layer: TileMapLayer) -> Vector2i:
	var grid_position_adjust = Vector2i(0, 1)
	var tile_coords = layer.local_to_map(layer.to_local(player.global_position)) + grid_position_adjust
	return tile_coords

func debug() -> void:
	var position_on_tilemaplayer := self.getPositionOnTileMapLayer(self, tilemap_layer_ground)
	var msg := "Player Debug:"
	msg += "\nPos:   [b]%d/%d[/b]" % [self.position.x, self.position.y]
	msg += "\nGRID:  [b]%d/%d[/b]" % [position_on_tilemaplayer.x, position_on_tilemaplayer.y]
	msg += "\nVel:   [b]%d/%d[/b]" % [self.velocity.x, self.velocity.y]
	msg += "\nJumps: [b]%d/%d[/b]" % [self.number_of_jumps, MAX_JUMPS]
	msg += "\nIsOnFloor: [b]%s[/b]" % [str(is_on_floor())]
	msg += "\nIsOnWall: [b]%s[/b]" % [str(is_on_wall())]
	msg += "\nIsOnceiling: [b]%s[/b]" % [str(is_on_ceiling())]
	msg += "\nIsFalling: [b]%s[/b]" % [str(is_falling)]
	msg += "\nLight: [b]%s[/b]" % str(is_light_on)
	%PlayerDebugLabel.text = msg
