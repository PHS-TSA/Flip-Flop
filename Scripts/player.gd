extends CharacterBody2D
signal pressed

@export var speed = 300.0
const JUMP_VELOCITY = -400.0

var wasdOrArrows = true #true = wasd false = arrows
var pause = false
var grabbing = false



func _input(event):
	if wasdOrArrows:
		if event.is_action_pressed("a") or event.is_action_pressed("d"):
			pressed.emit()
	else:
		if event.is_action_pressed("left") or event.is_action_pressed("right"):
			pressed.emit()
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not grabbing and not pause:
		velocity += get_gravity() * delta
	if not pause:
		if wasdOrArrows:
			if Input.is_action_just_pressed("w") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				
			var direction := Input.get_axis("a", "d")
			if direction:
				velocity.x = direction * speed
			else:
				velocity.x = move_toward(velocity.x, 0, speed/3)
		else:
			if Input.is_action_just_pressed("up") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				
			var direction := Input.get_axis("left", "right")
			if direction:
				velocity.x = direction * speed
			else:
				velocity.x = move_toward(velocity.x, 0, speed/3)

		move_and_slide()
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.mode != wasdOrArrows:
		wasdOrArrows = area.mode
		await get_tree().create_timer(0.1).timeout
		pause = true
		await pressed #wait for key press on movement player
		pause = false
