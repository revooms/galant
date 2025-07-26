extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_light_on: bool = false

@onready var point_light_2d: PointLight2D = $PointLight2D

func _ready() -> void:
	setLight(false)

func setLight(state: bool) -> void:
	is_light_on = state
	if is_light_on == true:
		point_light_2d.enabled = true
	else:
		point_light_2d.enabled = false

func toggleLight() -> void:
	setLight(!is_light_on)

func _process(_delta) -> void:
	debug()
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle light
	if Input.is_action_just_pressed("toggle_light"):
		toggleLight()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func debug() -> void:
	var msg = "Player Debug:"
	# var position_on_tilemaplayer = ""
	msg += "\nPos: [b]%d/%d[/b]" % [self.position.x, self.position.y]
	msg += "\nLight: [b]%s[/b]" % str(is_light_on)

	%RichTextLabel.text = msg
