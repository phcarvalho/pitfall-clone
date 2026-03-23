extends Node

var score := 2000
var game_time := 1200.0
var lifes := 2
var player: Node2D
var current_room := 0b11000100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	game_time -= delta
