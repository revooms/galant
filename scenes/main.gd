extends Node2D

const fade_steps = 50.0
const fade_timer = 0.02

@export var load_scene: PackedScene

@onready var black_fade_screen: ColorRect = $UI/BlackFadeScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fadeIn()
	await get_tree().create_timer(5).timeout
	fadeOut()
	loadScene()

func loadScene() -> void:
	get_tree().change_scene_to_packed(load_scene)

func fadeIn() -> void:
	# Von Alpha 1.0 → 0.0 (sichtbar → unsichtbar)
	for i in range(fade_steps, -1, -1):
		black_fade_screen.color.a = i / fade_steps
		await get_tree().create_timer(fade_timer).timeout

	black_fade_screen.visible = false

func fadeOut() -> void:
	black_fade_screen.visible = true
	# Von Alpha 0.0 → 1.0 (unsichtbar → schwarz)
	for i in range(0, fade_steps+1):
		black_fade_screen.color.a = i / fade_steps
		await get_tree().create_timer(fade_timer).timeout
