extends CharacterBody2D

@export var is_falling := false
@export var can_climb := false

var speed := 60
var jump_speed := -80
var gravity := 320
 
var hurt_speed_penalty := 0.4

var is_being_hurt := false
var is_facing_right := true
var is_climbing := false
var climbing_cooldown := 0.0
var climbing_delay := 0.15

@onready var anim := $AnimatedSprite2D

func _ready() -> void:
	game_state.player = self

func _physics_process(delta: float) -> void:
	if is_climbing:
		return
		
	if not is_on_floor():
		var velocity_y = clampf(velocity.y + gravity * delta, -80.0, 50.0)
		velocity.y = velocity_y
		
	else:
		var direction = Input.get_axis("walk_left", "walk_right")
		velocity.x = direction * speed
		
		if is_being_hurt:
			velocity.x *= hurt_speed_penalty
			
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_being_hurt:
		velocity.y = jump_speed
		
	move_and_slide()

func _process(delta):
	var current_anim := "default"
	
	if is_climbing:
		current_anim = "climbing"
		climbing_cooldown += delta
		if position.y <= 136:
			if Input.is_action_just_pressed("walk_left"):
				position.y = 116
				velocity.y = jump_speed
				velocity.x = -speed
				is_climbing = false
				is_facing_right = false
				anim.flip_h = true
				current_anim = "jump"
			if Input.is_action_just_pressed("walk_right"):
				is_facing_right = true
				position.y = 116
				velocity.y = jump_speed
				velocity.x = speed
				is_climbing = false
				anim.flip_h = false
				current_anim = "jump"
		elif climbing_cooldown >= climbing_delay:
			climbing_cooldown -= climbing_delay
			if Input.is_action_pressed("arrow_up"):
				position.y -= 4
				if position.y <= 136:
					position.y = 136
				else:
					anim.flip_h = !anim.flip_h
			elif Input.is_action_pressed("arrow_down"):
				position.y += 4
				if position.y >= 174:
					position.y = 174
					is_climbing = false
				else:
					anim.flip_h = !anim.flip_h
	elif can_climb and Input.is_action_pressed("arrow_up"):
		is_climbing = true
		is_falling = false
		climbing_cooldown = 0.0
		global_position.x = 151
		velocity = Vector2.ZERO
	else:
		if is_being_hurt:
			game_state.score -= 50 * delta
			current_anim = "hurt"
		
		if not is_on_floor():
			if not is_falling:
				current_anim = "jump"
		else:
			is_falling = false
			if velocity.x != 0:
				if not is_being_hurt:
					current_anim = "running"
					
				is_facing_right = velocity.x > 0
				anim.flip_h = !is_facing_right
			elif not is_being_hurt:
				anim.play("default")
	
	anim.play(current_anim)
		
func set_is_being_hurt(value: bool):
	is_being_hurt = value
	
func die(on_cave = false):
	get_tree().paused = true
	is_climbing = false
	climbing_cooldown = 0.0
	
	game_state.lifes -= 1
	if game_state.lifes >= 0:
		var timer = get_tree().create_timer(2, true, true)
		await timer.timeout
		position.x = 30
		position.y = position.y if on_cave else 100
		velocity = Vector2.ZERO
		get_tree().paused = false
		return true
		
	return false
	
	
