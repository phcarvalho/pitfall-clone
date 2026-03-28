extends Node2D

@onready var score = $CanvasLayer/ScoreLabel
@onready var minutes_timer = $CanvasLayer/MinutesLabel
@onready var seconds_timer = $CanvasLayer/SecondsLabel
@onready var lifes = $CanvasLayer/LifesLabel

@onready var current_life = game_state.lifes

@onready var current_level = $Level

var level := preload("res://scenes/level.tscn")

func _process(delta: float) -> void:
	var minutes = floor(game_state.game_time / 60.0)
	var seconds = int(game_state.game_time) % 60
	var seconds_str = ("%d" % seconds).lpad(2, "0")
	
	score.text = "%d" % game_state.score
	minutes_timer.text = "%d" % minutes
	seconds_timer.text = "%s" % seconds_str
	
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
	
func load_new_level(new_room, on_left = false, on_cave = false):
	call_deferred("do_load_new_level", new_room, on_left, on_cave)
	
func do_load_new_level(new_room, on_left = false, on_cave = false):
	game_state.current_room = new_room
	var new_level = level.instantiate()
	new_level.room = new_room
	new_level.is_player_on_cave = on_cave
	new_level.is_player_on_left = on_left
	add_child(new_level)
	current_level.queue_free()
	current_level = new_level

func _on_floor_right_body_entered(body: Node2D) -> void:
	var new_room = move_to_right_room(game_state.current_room)
	load_new_level(new_room, true)

func _on_floor_left_body_entered(body: Node2D) -> void:
	var new_room = move_to_left_room(game_state.current_room)
	load_new_level(new_room, false)


func _on_cave_right_body_entered(body: Node2D) -> void:
	var new_room = game_state.current_room
	for i in range(3):
		new_room = move_to_right_room(new_room)
	load_new_level(new_room, true, true)

func _on_cave_left_body_entered(body: Node2D) -> void:
	var new_room = game_state.current_room
	for i in range(3):
		new_room = move_to_left_room(new_room)
	load_new_level(new_room, false, true)
