extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.singleplayer:
		get_node("Label2").visible = false
		get_node("Label3").visible = false
		get_node("Label4").visible = false
		get_node("Label5").visible = false
		get_node("Label7").visible = true
		get_node("Label").txt = "WASD to move!"
	else:
		get_node("Label2").visible = true
		get_node("Label3").visible = true
		get_node("Label4").visible = true
		get_node("Label5").visible = true
		get_node("Label7").visible = false
		get_node("Label").txt = "WASD to move in fruit section!"

		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
