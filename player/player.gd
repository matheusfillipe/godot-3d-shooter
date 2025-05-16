extends CharacterBody3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.2
		%Camera3D.rotation_degrees.x -= event.relative.y * 0.2
		%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, -60.0, 60.0)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
	const speed = 5.5
	
	var input_direction_2D = Input.get_vector(
		"move_left", "move_right", "move_forward", "move_back"
	)
	var input_direction_3D = Vector3(
		input_direction_2D.x, 0.0, input_direction_2D.y
	)
	var direction = transform.basis * input_direction_3D
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	velocity.y -= 20.0 * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = 10.0
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = 0.0
	
	move_and_slide()
	
	if Input.is_action_pressed("shoot") and %ShootTimer.is_stopped():
		shoot()
	
func shoot():
	const Bullet = preload("res://player/bullet.tscn")
	var bullet = Bullet.instantiate()
	%Marker3D.add_child(bullet)
	
	bullet.global_transform = %Marker3D.global_transform
	%ShootTimer.start()
