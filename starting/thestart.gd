extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#%CheckButton.rect_min_size = Vector2(45, 45)
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://Level.tscn")


#func _on_singleplayer_pressed() -> void:
	#Globals.singleplayer = true
	#get_tree().change_scene_to_file.call_deferred("res://Level.tscn")


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Globals.singleplayer = true
	else:
		Globals.singleplayer = false
