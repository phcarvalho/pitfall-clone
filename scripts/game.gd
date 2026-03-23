extends Node2D

@onready var score = $CanvasLayer/ScoreLabel
@onready var timer = $CanvasLayer/TimerLabel
@onready var lifes = $CanvasLayer/LifesLabel

@onready var current_life = game_state.lifes

@onready var current_level = $Level

var level := preload("res://scenes/level.tscn")

func _process(delta: float) -> void:
	var minutes = floor(game_state.game_time / 60.0)
	var seconds = int(game_state.game_time) % 60
	var seconds_str = ("%d" % seconds).lpad(2, "0")
	
	score.text = "%d" % game_state.score
	timer.text = "%d:%s" % [minutes, seconds_str]
	
	if current_life != game_state.lifes:
		current_life = game_state.lifes
		var life_text := ""
		for i in range(current_life):
			life_text += "|"
		lifes.text = life_text
		
func move_to_left_room(room: int):
	var next_room = (room >> 1) & 0xFF
	
	var bit0 = room & 1
	var bit4 = (room >> 4) & 1
	var bit5 = (room >> 5) & 1
	var bit6 = (room >> 6) & 1
	
	next_room |= (bit0 ^ bit4 ^ bit5 ^ bit6) << 7
	return next_room
	
func move_to_right_room(room: int):
	var next_room = (room << 1) & 0xFF
	
	var bit3 = (room >> 3) & 1
	var bit4 = (room >> 4) & 1
	var bit5 = (room >> 5) & 1
	var bit7 = (room >> 7) & 1
	
	next_room |= bit3 ^ bit4 ^ bit5 ^ bit7
	return next_room


func _on_floor_right_body_entered(body: Node2D) -> void:
	game_state.current_room = move_to_right_room(game_state.current_room)
	current_level.queue_free()
	var new_level = level.instantiate()
	new_level.room = game_state.current_room
	add_child(new_level)
	current_level = new_level


func _on_floor_left_body_entered(body: Node2D) -> void:
	game_state.current_room = move_to_left_room(game_state.current_room)
	current_level.queue_free()
	var new_level = level.instantiate()
	new_level.room = game_state.current_room
	new_level.is_player_on_left = false
	add_child(new_level)
	current_level = new_level


func _on_cave_right_body_entered(body: Node2D) -> void:
	for i in range(3):
		game_state.current_room = move_to_right_room(game_state.current_room)
		
	current_level.queue_free()
	var new_level = level.instantiate()
	new_level.room = game_state.current_room
	new_level.is_player_on_cave = true
	add_child(new_level)
	current_level = new_level


func _on_cave_left_body_entered(body: Node2D) -> void:
	for i in range(3):
		game_state.current_room = move_to_left_room(game_state.current_room)
		
	current_level.queue_free()
	var new_level = level.instantiate()
	new_level.room = game_state.current_room
	new_level.is_player_on_cave = true
	new_level.is_player_on_left = false
	add_child(new_level)
	current_level = new_level
