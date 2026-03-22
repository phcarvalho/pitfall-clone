extends Node2D

@onready var score = $CanvasLayer/ScoreLabel
@onready var timer = $CanvasLayer/TimerLabel
@onready var lifes = $CanvasLayer/LifesLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var minutes = floor(game_state.game_time / 60.0)
	var seconds = int(game_state.game_time) % 60
	
	score.text = "%d" % game_state.score
	timer.text = "%d:%d" % [minutes, seconds]
