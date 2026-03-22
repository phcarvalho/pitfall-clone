extends Node2D

var room = 0b11000100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(String.num_int64(room, 2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#var print = false
	#if Input.is_action_just_pressed("room_left"):
		#move_to_left_room()
	#elif Input.is_action_just_pressed("room_right"):
		#move_to_right_room()

func move_to_left_room():
	var next_room = (room >> 1) & 0xFF
	
	var bit0 = room & 1
	var bit4 = (room >> 4) & 1
	var bit5 = (room >> 5) & 1
	var bit6 = (room >> 6) & 1
	
	next_room |= (bit0 ^ bit4 ^ bit5 ^ bit6) << 7
	room = next_room
	print(String.num_int64(room, 2))
	
func move_to_right_room(going_right = true):
	var next_room = ((room << 1) if going_right else (room >> 1)) & 0xFF
	
	var bit3 = (room >> 3) & 1
	var bit4 = (room >> 4) & 1
	var bit5 = (room >> 5) & 1
	var bit7 = (room >> 7) & 1
	
	next_room |= bit3 ^ bit4 ^ bit5 ^ bit7
	room = next_room
	print(String.num_int64(room, 2))
	
