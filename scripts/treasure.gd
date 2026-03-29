extends Area2D

func _ready():
	if game_state.collected_treasures.has(game_state.current_room):
		self.queue_free()
		
func _on_body_entered(body: Node2D) -> void:
	game_state.add_treasure(self.name)
	self.queue_free()
