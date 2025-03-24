extends Node2D

@export var player = true #true = wasd false = arrows
var playerin = false
var bodi

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.singleplayer == false:
		if player == true:
			if Input.is_action_pressed("wasdgrab"):
				if playerin:
					bodi.velocity.y = -1800
				%pre.visible = false
				$Up.visible = true
				await get_tree().create_timer(0.1).timeout
				get_node("Up/StaticBody2D/CollisionShape2D").disabled = false 
			else:
				%pre.visible = true
				$Up.visible = false
				get_node("Up/StaticBody2D/CollisionShape2D").disabled = true 
		else:
			if Input.is_action_pressed("arrowsgrab"):
				if playerin:
					bodi.velocity.y = -1800
				%pre.visible = false
				$Up.visible = true
				await get_tree().create_timer(0.1).timeout
				get_node("Up/StaticBody2D/CollisionShape2D").disabled = false 
			else:
				%pre.visible = true
				$Up.visible = false
				get_node("Up/StaticBody2D/CollisionShape2D").disabled = true 
	else:
		if Input.is_action_pressed("wasdgrab"):
			if playerin:
				bodi.velocity.y = -1800
			%pre.visible = false
			$Up.visible = true
			await get_tree().create_timer(0.1).timeout
			get_node("Up/StaticBody2D/CollisionShape2D").disabled = false 
		else:
			%pre.visible = true
			$Up.visible = false
			get_node("Up/StaticBody2D/CollisionShape2D").disabled = true 


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		playerin = true
		bodi = body

		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		playerin = false
		bodi = body
