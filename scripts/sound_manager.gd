extends Node

var sound_player := AudioStreamPlayer.new()

var sounds := {
	"jump": preload("res://assets/sounds/jump.wav"),
	"die": preload("res://assets/sounds/die.wav"),
	"barrel": preload("res://assets/sounds/barrel.mp3"),
	"falling": preload("res://assets/sounds/falling.wav"),
	"treasure": preload("res://assets/sounds/treasure.wav")
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	sounds["barrel"].loop = true
	add_child(sound_player)
 
func play_sound(sound_name):
	sound_player.stream = sounds[sound_name]
	sound_player.play()

func stop_sound():
	sound_player.stop()
