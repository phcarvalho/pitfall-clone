extends Node2D


func _on_hole_area_body_entered(body: Node2D) -> void:
	body.velocity.x = 0
	body.velocity.y = 300
	body.is_falling = true


func _on_stairs_body_entered(body: Node2D) -> void:
	body.can_climb = true


func _on_stairs_body_exited(body: Node2D) -> void:
	body.can_climb = false
