extends Sprite2D

func _on_slip(body: Node2D) -> void:
	if body.name == "Player":
		body.onice += 1

func _on_slip_exit(body: Node2D) -> void:
	if body.name == "Player":
		body.onice -= 1
