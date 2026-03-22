extends StaticBody2D

@onready var closed_shape := $ClosedShape
@onready var opened_shape := $OpenedShape
@onready var anim := $AnimatedSprite2D

var is_opened := true


func _on_timer_timeout() -> void:
	is_opened = not is_opened
	
	if is_opened:
		opened_shape.disabled = false
		closed_shape.disabled = true
		anim.play("opened")
	else:
		opened_shape.disabled = true
		closed_shape.disabled = false
		anim.play("closed")
