extends Area2D

@onready var cave_front = $CaveFront

func _ready() -> void:
	cave_front.visible = false

func _on_body_entered(body: Node2D) -> void:
	body.velocity.x = 0
	body.velocity.y = 300
	body.is_falling = true
	cave_front.visible = true


func _on_body_exited(body: Node2D) -> void:
	if await body.die():
		cave_front.visible = false
