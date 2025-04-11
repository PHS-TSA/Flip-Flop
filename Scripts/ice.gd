extends Sprite2D

func _process(delta: float) -> void:
	if get_node("Area2D").has_overlapping_bodies() and get_node("Area2D").get_overlapping_bodies().any(func bleg(body): return body.name == "Player"):
		Globals.onice = true
	else:
		Globals.onice = false
		print(Globals.onice)
