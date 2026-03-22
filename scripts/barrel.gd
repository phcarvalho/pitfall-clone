extends Area2D

@export var is_static = false
@export var speed = 50

@onready var anim = $AnimatedSprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_static:
		return
	
	anim.play("move")
		
	position.x += -speed * delta
		
	if position.x < -16:
		position.x = get_viewport_rect().size.x + 16


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("set_is_being_hurt"):
		body.set_is_being_hurt(true)


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("set_is_being_hurt"):
		body.set_is_being_hurt(false)
