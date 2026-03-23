extends Area2D

var speed := 15
var is_facing_left := true

@onready var anim := $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not game_state.player:
		return
		
	var player_pos_x = game_state.player.position.x
	if  position.x == player_pos_x:
		anim.play("default")
		return

	if position.x < player_pos_x:
		position.x += speed * delta
		if position.x > player_pos_x:
			position.x = player_pos_x
		is_facing_left = false
	else:
		position.x -= speed * delta
		if position.x < player_pos_x:
			position.x = player_pos_x
		is_facing_left = true
		
	anim.play("move")
	anim.flip_h = not is_facing_left


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		var reset = await body.die()
		if reset:
			position.x = floor(get_viewport_rect().size.x / 2)
			position.y = 100
