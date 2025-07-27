extends Node

# Singleton-Instanz
@export var sound_categories: Dictionary = {}  # {"ui": ["res://sounds/ui_click.wav", ...], "environment": [...]}
@export var category_volumes: Dictionary = {}  # {"ui": 0.5, "environment": 0.2}

# AudioStreamPlayer
var sound_player: AudioStreamPlayer = null

func _ready():
	sound_player = get_node("AudioStreamPlayer")
	sound_player.volume_db = 0.0  # Initialisierung
	sound_player.autoplay = false

	# Beispiel: Kategorien und Volumes füllen
	sound_categories["player_flashlight"] = ["res://assets/audio/fx/flashlight_on.ogg", "res://assets/audio/fx/flashlight_off.ogg"]
	category_volumes["player_flashlight"] = 0.5
	# sound_categories["environment"] = ["res://sounds/environment_wind.wav", "res://sounds/environment_rain.wav"]
	# category_volumes["environment"] = 0.2

func play_sound(category: String, sound_name: String):
	if not is_instance_valid(sound_player):
		return

	# Überprüfe, ob die Kategorie und der Sound existieren
	if not sound_categories.has(category) or not sound_categories[category].has(sound_name):
		print("Sound nicht gefunden in Kategorie:", category)
		return

	# Lade den Sound
	var sound = load(sound_name)
	if sound is AudioStream:
		sound_player.stream = sound
		sound_player.volume_db = category_volumes.get(category, 0.0)  # Setze Volume
		sound_player.play()
	else:
		print("Sound nicht gefunden:", sound_name)

func play_random_sound(category: String):
	if not is_instance_valid(sound_player) or not sound_categories.has(category):
		return

	var sounds = sound_categories[category]
	if sounds.size() == 0:
		print("Keine Sounds in Kategorie:", category)
		return

	var random_index = randi() % sounds.size()
	var random_sound = sounds[random_index]
	play_sound(category, random_sound)
