extends Node2D


func _ready() -> void:
	self.visible = true
	get_node("Area2D/CollisionPolygon2D").set_deferred("disabled",false)
	
func _on_carrot_collected(body: Node2D) -> void:
	Globals.carrots += 1
	self.visible = false
	get_node("Area2D/CollisionPolygon2D").set_deferred("disabled",true)
