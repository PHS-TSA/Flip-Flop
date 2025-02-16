extends CharacterBody2D
signal pressed

@export var speed = 300.0
const JUMP_VELOCITY = -600.0

var wasdOrArrows = true #true = wasd false = arrows
var pause = false
var grabbing = false
var walljump = false
var crouching

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
		
	#if crouching:
		#%StandingSprite.visible = false
		#%StandingCollison.disabled = true
		#%StandingArea.monitoring = false
		#%StandingArea.monitorable = false
		#
		#%DownSprite.visible = true
		#%DownCollison.disabled = false
		#%DownArea.monitoring = true
		#%DownArea.monitorable = true
	#else:
		#%StandingSprite.visible = true
		#%StandingCollison.disabled = false
		#%StandingArea.monitoring = true
		#%StandingArea.monitorable = true
		#
		#%DownSprite.visible = false
		#%DownCollison.disabled = true
		#%DownArea.monitoring = false
		#%DownArea.monitorable = false
		
	if not pause:
		if wasdOrArrows:
			if Input.is_action_just_pressed("w") and (is_on_floor() or grabbing):
				velocity.y = JUMP_VELOCITY
				if grabbing:
					var direction := Input.get_axis("a", "d")
					walljump = true
					velocity.x = -direction * (speed)
					await get_tree().create_timer(0.3).timeout
					walljump = false
	
			var direction := Input.get_axis("a", "d")
			if direction and not walljump:
				velocity.x = direction * speed
			elif not walljump:
				velocity.x = move_toward(velocity.x, 0, speed/3)
			
			if is_on_wall() and Input.is_action_pressed("wasdgrab"):
				grabbing = true
			else:
				grabbing = false
			
			#if Input.is_action_pressed("down"):
				#crouching = true
			#else:
				#crouching = false
				
		else:
			if Input.is_action_just_pressed("up") and (is_on_floor() or grabbing):
				velocity.y = JUMP_VELOCITY
				if grabbing:
					var direction := Input.get_axis("left", "right")
					walljump = true
					velocity.x = -direction * (speed)
					await get_tree().create_timer(0.3).timeout
					walljump = false
					
					
			
				
			var direction := Input.get_axis("left", "right")
			if direction and not(walljump):
				velocity.x = direction * speed
			elif not walljump:
				velocity.x = move_toward(velocity.x, 0, speed/3)
				
			if is_on_wall() and Input.is_action_pressed("arrowsgrab"):
				grabbing = true
			else:
				grabbing = false
			
			#if Input.is_action_pressed("s"):
				#crouching = true
			#else:
				#crouching = false
				
				
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
	
