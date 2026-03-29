extends Node

var score := 2000
var game_time := 1200.0
var lifes := 2
var player: Node2D
var current_room := 0b11000100
var collected_treasures = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	game_time -= delta
	
func add_treasure(treasure_name):
	sound_manager.play_sound("treasure")
	match treasure_name:
		"GoldSack":
			score += 2000
		"SilverBar":
			score += 3000
		"GoldBar":
			score += 4000
		"DiamondRing":
			score += 5000
	
	collected_treasures.push_back(current_room)
	
	if collected_treasures.size() >= 32:
		get_node("/root/Game").end_game()
