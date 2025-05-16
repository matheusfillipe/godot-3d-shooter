extends RigidBody3D

var health = 3
var speed = randf_range(2, 4)

@onready var bat_model = %bat_model
@onready var player = get_node("/root/Game/Player")

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	direction.y = 0.0
	linear_velocity = direction * speed
	bat_model.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + PI

func take_damage():
	if health == 0:
		return
		
	bat_model.hurt()
	health -= 1
	if health == 0:
		set_physics_process(false)
		gravity_scale = 1.0
		var direction = -global_position.direction_to(player.global_position)
		var random_upward_force = Vector3.UP * randf_range(1.0, 5.0)
		apply_central_impulse(direction * 10.0 + random_upward_force)
		%DeathTimer.start()
		lock_rotation = false


func _on_death_timer_timeout() -> void:
	queue_free()
