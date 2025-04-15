extends Node2D

var playerin = false
var playerbody = null
var xspd = 0
var yspd = 0
@export var speed = 700


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		playerin = true
		playerbody = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		playerin = false
		playerbody = null

func _physics_process(delta: float) -> void:
	if playerin:
		pass
		#if roundi(self.rotation_degrees) == -90:
			#xspd = -speed * 2
			#yspd = 0
		#elif roundi(self.rotation_degrees) == -45:
			#xspd = -speed
			#yspd = -speed
		#elif roundi(self.rotation_degrees) == 0:
			#xspd = 0
			#yspd = -speed
		#elif roundi(self.rotation_degrees) == 45:
			#xspd = speed
			#yspd = -speed
		#elif roundi(self.rotation_degrees) == 90:
			#xspd = speed * 2
			#yspd = 0
			#
		#if xspd != 0:
			#playerbody.velocity.x = xspd 
		#if yspd != 0:
			#playerbody.velocity.y = yspd
