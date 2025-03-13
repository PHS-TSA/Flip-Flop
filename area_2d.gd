extends Area2D
@export var level = ""


#func _on_area_entered(area: Area2D) -> void:
	#get_tree().change_scene_to_file.call_deferred(level)
	#print("entered")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file.call_deferred(level)
