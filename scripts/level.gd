extends Node2D

@export var room := 0b11000100
@export var is_player_on_cave := false
@export var is_player_on_left := true

@onready var object_marker := $ObjectMarker
@onready var floor_marker := $FloorMarker
@onready var cave_marker := $CaveMarker

var backgrounds := {
	"00": preload("res://scenes/backgrounds/background_01.tscn"),
	"01": preload("res://scenes/backgrounds/background_02.tscn"),
	"10": preload("res://scenes/backgrounds/background_03.tscn"),
	"11": preload("res://scenes/backgrounds/background_04.tscn"),
}

var barrels_manager := preload("res://scenes/barrels_manager.tscn")
var player := preload("res://scenes/player.tscn")
var scorpion := preload("res://scenes/scorpion.tscn")
var wall := preload("res://scenes/wall.tscn")

func _ready() -> void:
	load_background()
	load_barrel()
	load_cave()
	spawn_player()

func get_bits(value: int, start: int, size: int):
	var mask = (1 << size) - 1
	return (value >> start) & mask
	
func get_bits_text(value: int, size: int):
	return String.num_int64(value, 2).lpad(size, "0")

func load_background():
	var background_bits = get_bits(room, 6, 2)
	var background = backgrounds[get_bits_text(background_bits, 2)].instantiate()
	
	if not background:
		printerr("background not found")
		return
		
	background.position = position
	add_child(background)
	
func load_barrel():
	var barrel_bits = get_bits(room, 0, 3)
	var manager = barrels_manager.instantiate()
	manager.position = object_marker.position
	add_child(manager)
	
	manager.spawn_barrels(get_bits_text(barrel_bits, 3))
	
func spawn_player():
	var position_x = 30 if is_player_on_left else get_viewport_rect().size.x - 30
	var position_y = cave_marker.position.y if is_player_on_cave else floor_marker.position.y
	var player_instance = player.instantiate()
	player_instance.position = Vector2(position_x, position_y)
	add_child(player_instance)
	
func load_cave():
	var floor_bits = get_bits(room, 3, 3)
	var floor_bits_text = get_bits_text(floor_bits, 3)
	var has_wall = floor_bits_text == "000" or floor_bits_text == "001"
	
	if has_wall:
		var wall_bit = get_bits(room, 7, 1)
		var is_wall_on_left = wall_bit == 0
		var wall_instance = wall.instantiate()
		var position_x = 30 if is_wall_on_left else get_viewport_rect().size.x - 30
		wall_instance.position = Vector2(position_x, cave_marker.position.y)
		add_child(wall_instance)
	else:
		var scorpion_instance = scorpion.instantiate()
		scorpion_instance.position = cave_marker.position
		add_child(scorpion_instance)
	
	
	
	
	
	
	
	
	
	
