extends CharacterBody2D

@export var speed := 50
@export var jump_speed := -80
@export var gravity := 300

var hurt_speed_penalty := 0.5

var is_being_hurt := false
var is_facing_right := true

@onready var anim := $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y +=  gravity * delta
	else:
		var direction = Input.get_axis("walk_left", "walk_right")
		velocity.x = direction * speed
		
		if is_being_hurt:
			velocity.x *= hurt_speed_penalty 
	
	move_and_slide()
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_being_hurt:
		velocity.y = jump_speed

func _process(delta):
	if is_being_hurt:
		game_state.score -= 50 * delta
		anim.play("hurt")
	
	if not is_on_floor():
		anim.play("jump")
	elif velocity.x != 0:
		if not is_being_hurt:
			anim.play("running")
			
		var direction = Input.get_axis("walk_left", "walk_right")
		is_facing_right = direction > 0
		anim.flip_h = !is_facing_right
	elif not is_being_hurt:
		anim.play("default")
		
func set_is_being_hurt(value: bool):
	is_being_hurt = value
