extends Area2D

@onready var cave_front = $CaveFront
@onready var anim_front = $AnimationFront
@onready var anim_back = $AnimationBack
@onready var timer = $Timer

var is_closing := true

@onready var left_shape = $LeftSide/CollisionShape2D
@onready var right_shape = $RightSide/CollisionShape2D

var collision_sizes = [0, 16, 32, 66, 116, 132]

func _ready() -> void:
	cave_front.visible = false
	
func play_animation():
	var anim_name = "closing" if is_closing else "opening"
	anim_back.play(anim_name)
	anim_front.play(anim_name)

func _on_body_entered(body: Node2D) -> void:
	body.velocity.x = 0
	body.velocity.y = 300
	body.is_falling = true
	cave_front.visible = true

func _on_body_exited(body: Node2D) -> void:
	if await body.die():
		cave_front.visible = false

func _on_animation_back_animation_finished() -> void:
	is_closing = not is_closing
	$Timer.start(2)


func _on_timer_timeout() -> void:
	play_animation()


func _on_animation_back_frame_changed() -> void:
	var index = anim_back.frame if is_closing else 5 - anim_back.frame
	left_shape.shape.size.x = collision_sizes[index]
	right_shape.shape.size.x = collision_sizes[index]
