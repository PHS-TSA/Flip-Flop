extends CharacterBody2D
signal pressed
signal slept

@export var speed = 300.0
@export var level = ""
@export var leveltxt = ""
const JUMP_VELOCITY = -600.0

var wasdOrArrows = true #true = wasd false = arrows
var pause = false
var grabbing = false
var walljump = false
var jumping = false
var walking = false
var stamina = 100
var secretstamina = 100
var pausedclimb = true
var sleepy = false
var carrotcolected = false

var onice = 0
var jumpedonice = false

var onladder = false

func _ready() -> void:
	%Sprite.set_autoplay("idle")
	%BIG.text = leveltxt
	#%BIG.visible = true
	%bg.visible = true
	await get_tree().create_timer(0.1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(%BIG, "modulate", Color(255,255,255,0), 4)
	tween.parallel().tween_property(%bg, "self_modulate", Color(0,0,0,0), 2.5)
	tween.tween_callback(%BIG.queue_free)


func _input(event):
	if wasdOrArrows:
		if event.is_action_pressed("a") or event.is_action_pressed("d"):
			pressed.emit()
	else:
		if event.is_action_pressed("left") or event.is_action_pressed("right"):
			pressed.emit()
	
	if event.is_action_pressed("space"):
		slept.emit()
		
func _physics_process(delta: float) -> void:
	if not sleepy:
		# Add the gravity.
		if wasdOrArrows:
			if not is_on_floor() and not grabbing and not pause and not (onladder and Input.is_action_just_pressed("wasdgrab")):
				velocity += get_gravity() * delta
			if not is_on_floor() and grabbing and not pause and not (onladder and Input.is_action_just_pressed("wasdgrab")):
				velocity += get_gravity() * delta/2
		else:
			if not is_on_floor() and not grabbing and not pause and not (onladder and Input.is_action_just_pressed("arrowsgrab")):
				velocity += get_gravity() * delta
			if not is_on_floor() and grabbing and not pause and not (onladder and Input.is_action_just_pressed("arrowsgrab")):
				velocity += get_gravity() * delta/2
			
		if not pause:
			if Input.is_action_pressed("wasdgrab") or Input.is_action_pressed("arrowsgrab"):
				secretstamina -= 0.01
			
		if not pause:
			if wasdOrArrows:
				if is_on_floor() and not grabbing:
					jumping = false
					if jumpedonice == true:
						onice -= 1
						jumpedonice = false
					
				if is_on_floor() and not is_on_wall() and not walking and not jumping and not grabbing:
					%Sprite.play("idle")
					
				if is_on_wall() and Input.is_action_pressed("wasdgrab") and not onladder:
					if grabbing == false:
						%Sprite.play("wall_grab")
					secretstamina -= 0.1
					grabbing = true
					jumping = false
				else:
					grabbing = false
					
				if Input.is_action_just_pressed("w") and (is_on_floor() or grabbing) and not (onladder and Input.is_action_pressed("wasdgrab")):
					if onice == 0:
						velocity.y = JUMP_VELOCITY
					else:
						velocity.y = JUMP_VELOCITY
						onice += 1
						jumpedonice = true
						
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
					if onice == 0:
						velocity.x = direction * speed
					else:
						velocity.x = move_toward(velocity.x, direction * (speed * 2), speed/40)
					if not jumping and not grabbing and not onladder:
						%Sprite.play("walk")
					walking = true
				elif not walljump:
					if onice == 0:
						velocity.x = move_toward(velocity.x, 0, speed/3)
					else:
						velocity.x = move_toward(velocity.x, 0, speed/80)
					walking = false
				
				if onladder and Input.is_action_pressed("wasdgrab"):
					if %Sprite.animation != "climb":
						%Sprite.play("climb")
					secretstamina -= 0.01
					if Input.is_action_pressed("w"):
						if pausedclimb:
							%Sprite.play("climb")
							pausedclimb = false
						velocity.y = move_toward(velocity.y, -300, speed/3)
					elif Input.is_action_pressed("s"):
						if pausedclimb:
							%Sprite.play("climb")
							pausedclimb = false
						velocity.y = move_toward(velocity.y, 300, speed/3)
					elif Input.is_action_pressed("a") or Input.is_action_pressed("d"):
						if pausedclimb:
							%Sprite.play("climb")
							pausedclimb = false
						velocity.y = 0
					else:
						pausedclimb = true
						%Sprite.pause()
						velocity.y = 0
					
					
			else: #arrows
				
				if is_on_floor() and not grabbing:
					jumping = false
					if jumpedonice == true:
						onice -= 1
						jumpedonice = false
					
				if is_on_floor() and not is_on_wall() and not walking and not jumping and not grabbing:
					%Sprite.play("idle")
					
				if is_on_wall() and Input.is_action_pressed("arrowsgrab") and not onladder:
					if grabbing == false:
						%Sprite.play("wall_grab")
					secretstamina -= 0.1
					grabbing = true
					jumping = false
				else:
					grabbing = false
					
				if Input.is_action_just_pressed("up") and (is_on_floor() or grabbing) and not (onladder and Input.is_action_pressed("arrowsgrab")):
					if onice == 0:
						velocity.y = JUMP_VELOCITY
					else:
						velocity.y = JUMP_VELOCITY
						onice += 1
						jumpedonice = true
					
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
					if onice == 0:
						velocity.x = direction * speed
					else:
						velocity.x = move_toward(velocity.x, direction * (speed * 2), speed/40)
					if not jumping and not grabbing and not onladder:
						%Sprite.play("walk")
					walking = true
				elif not walljump:
					if onice == 0:
						velocity.x = move_toward(velocity.x, 0, speed/3)
					else:
						velocity.x = move_toward(velocity.x, 0, speed/80)
					walking = false
					
				if onladder and Input.is_action_pressed("arrowsgrab"):
					if %Sprite.animation != "climb":
						%Sprite.play("climb")
					secretstamina -= 0.01
					if Input.is_action_pressed("up"):
						if pausedclimb:
							%Sprite.play("climb")
							pausedclimb = false
						velocity.y = move_toward(velocity.y, -300, speed/3)
					elif Input.is_action_pressed("down"):
						if pausedclimb:
							%Sprite.play("climb")
							pausedclimb = false
						velocity.y = move_toward(velocity.y, 300, speed/3)
					elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
						if pausedclimb:
							%Sprite.play("climb")
							pausedclimb = false
						velocity.y = 0
					else:
						pausedclimb = true
						%Sprite.pause()
						velocity.y = 0

			if velocity.y > 0 and not onladder and not grabbing and $Sprite.animation != "wall_jump":
				%Sprite.play("fall")
			stamina = roundi(secretstamina)
			%Stamina.text = "Stamina: " + str(stamina)
			if stamina <= 0:
				sleepy = true
				if %Sprite.flip_h:
						%Sprite.flip_h = false
				while not is_on_floor():
					velocity.y = 1200
					%Sprite.play("fall")
					velocity.x = 0
					await get_tree().create_timer(0.001).timeout
					move_and_slide()
				%Sprite.play("sleep")
				await get_tree().create_timer(1.4).timeout
				%Sprite.play("sleeploop")
				%WASDlabel.text = "SPACE to \nrestart!"
				await slept
				get_tree().change_scene_to_file.call_deferred(level)
			move_and_slide()
			
func _on_area_2d_area_entered(area: Area2D) -> void:
	if not Globals.singleplayer:
		wasdOrArrows = false
		await get_tree().create_timer(0.1).timeout
		%WASDlabel.text = "ARWS"
		pause = true
		await pressed #wait for key press on movement player
		pause = false
	
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	if not Globals.singleplayer:
		wasdOrArrows = true
		await get_tree().create_timer(0.1).timeout
		%WASDlabel.text = "WASD"
		pause = true
		await pressed #wait for key press on movement player
		pause = false
	


func _on_ladder_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		onladder = true
		


func _on_ladder_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		onladder = false


func _on_pillows_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		sleepy = true
		if %Sprite.flip_h:
				%Sprite.flip_h = false
		while not is_on_floor():
			velocity.y = 1200
			%Sprite.play("fall")
			velocity.x = 0
			await get_tree().create_timer(0.001).timeout
			move_and_slide()
		%Sprite.play("sleep")
		await get_tree().create_timer(1.4).timeout
		%Sprite.play("sleeploop")
		%WASDlabel.text = "SPACE to \nrestart!"
		await slept
		get_tree().change_scene_to_file.call_deferred(level)
