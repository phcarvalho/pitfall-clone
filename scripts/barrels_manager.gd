extends Node2D

var barrel := preload("res://scenes/barrel.tscn")

var barrel_settings = {
	"000": { is_static = false, count = 1 },
	"001": { is_static = false, count = 2 },
	"010": { is_static = false, count = 2, space = 60 },
	"011": { is_static = false, count = 3, space = 60 },
	"100": { is_static = true, count = 1 },
	"101": { is_static = true, count = 3, space = 60 },
}

var space := 32

func spawn_barrels(setting_key: String):
	var setting = barrel_settings.get(setting_key)

	if not setting:
		return
	
	var is_static = setting.is_static
	var count = setting.count
	var current_space = space
	if "space" in setting:
		current_space = setting.space

	for i in range(count):
		var barrel_instance = barrel.instantiate()
		barrel_instance.is_static = is_static
		barrel_instance.position = position
		barrel_instance.position.x += -(count - 1) * current_space + (i * current_space)
		get_parent().add_child(barrel_instance)
