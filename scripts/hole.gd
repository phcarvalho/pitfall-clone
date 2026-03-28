extends Area2D

func _on_body_entered(body: Node2D) -> void:
	body.velocity.x = 0
	body.velocity.y = 300
	body.is_falling = true
