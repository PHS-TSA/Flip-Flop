extends CharacterBody2D
signal pressed

@export var speed = 300.0
const JUMP_VELOCITY = -600.0

var wasdOrArrows = true #true = wasd false = arrows
var pause = false
var grabbing = false
var walljump = false
var jumping = false
var walking = false

func _ready() -> void:
	%Sprite.set_autoplay("idle")

func _input(event):
	if wasdOrArrows:
		if event.is_action_pressed("a") or event.is_action_pressed("d"):
			pressed.emit()
	else:
		if event.is_action_pressed("left") or event.is_action_pressed("right"):
			pressed.emit()
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not grabbing and not pause :
		velocity += get_gravity() * delta
	if not is_on_floor() and grabbing and not pause :
		velocity += get_gravity() * delta/2
		
	if not pause:
		if wasdOrArrows:
			if is_on_floor() and not grabbing:
				jumping = false
				
			if is_on_floor() and not is_on_wall() and not walking and not jumping and not grabbing:
				%Sprite.play("idle")
				
			if is_on_wall() and Input.is_action_pressed("wasdgrab"):
				if grabbing == false:
					%Sprite.play("wall_grab")
				grabbing = true
				jumping = false
			else:
				grabbing = false
				
			if Input.is_action_just_pressed("w") and (is_on_floor() or grabbing):
				velocity.y = JUMP_VELOCITY
				if not grabbing:
					%Sprite.play("jump")
					jumping = true
					
				if grabbing:
					if jumping == false:
						%Sprite.play("wall_jump")
					var direction := Input.get_axis("a", "d")
					walljump = true
					velocity.x = -direction * (speed)
					if direction > 0:
						%Sprite.flip_h = true
					elif direction < 0:
						%Sprite.flip_h = false
					await get_tree().create_timer(0.3).timeout
					jumping = true
					walljump = false
				
			var direction := Input.get_axis("a", "d")
			if not walljump:
				if direction < 0:
					%Sprite.flip_h = true
				elif direction > 0:
					%Sprite.flip_h = false

			if direction and not(walljump):
				velocity.x = direction * speed
				if not jumping and not grabbing:
					%Sprite.play("walk")
				walking = true
			elif not walljump:
				velocity.x = move_toward(velocity.x, 0, speed/3)
				walking = false
				
		else: #arrows
			
			if is_on_floor() and not grabbing:
				jumping = false
				
			if is_on_floor() and not is_on_wall() and not walking and not jumping and not grabbing:
				%Sprite.play("idle")
				
			if is_on_wall() and Input.is_action_pressed("arrowsgrab"):
				if grabbing == false:
					%Sprite.play("wall_grab")
				grabbing = true
				jumping = false
			else:
				grabbing = false
				
			if Input.is_action_just_pressed("up") and (is_on_floor() or grabbing):
				velocity.y = JUMP_VELOCITY
				
				if not grabbing:
					%Sprite.play("jump")
					jumping = true
					
				if grabbing:
					if jumping == false:
						%Sprite.play("wall_jump")
					var direction := Input.get_axis("left", "right")
					walljump = true
					velocity.x = -direction * (speed)
					if direction > 0:
						%Sprite.flip_h = true
					elif direction < 0:
						%Sprite.flip_h = false
					await get_tree().create_timer(0.3).timeout
					jumping = true
					walljump = false
					
					
			
				
			var direction := Input.get_axis("left", "right")
			if not walljump:
				if direction < 0:
					%Sprite.flip_h = true
				elif direction > 0:
					%Sprite.flip_h = false

			if direction and not(walljump):
				velocity.x = direction * speed
				if not jumping and not grabbing:
					%Sprite.play("walk")
				walking = true
			elif not walljump:
				velocity.x = move_toward(velocity.x, 0, speed/3)
				walking = false
			
				
		move_and_slide()
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	wasdOrArrows = false
	await get_tree().create_timer(0.1).timeout
	%WASDlabel.text = "ARWS"
	pause = true
	await pressed #wait for key press on movement player
	pause = false
	
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	wasdOrArrows = true
	await get_tree().create_timer(0.1).timeout
	%WASDlabel.text = "WASD"
	pause = true
	await pressed #wait for key press on movement player
	pause = false
	
