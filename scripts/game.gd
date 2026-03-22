extends Node2D

@onready var score = $CanvasLayer/ScoreLabel
@onready var timer = $CanvasLayer/TimerLabel
@onready var lifes = $CanvasLayer/LifesLabel

@onready var current_life = game_state.lifes

func _process(delta: float) -> void:
	var minutes = floor(game_state.game_time / 60.0)
	var seconds = int(game_state.game_time) % 60
	
	score.text = "%d" % game_state.score
	timer.text = "%d:%d" % [minutes, seconds]
	
	if current_life != game_state.lifes:
		current_life = game_state.lifes
		var life_text := ""
		for i in range(current_life):
			life_text += "|"
		lifes.text = life_text
