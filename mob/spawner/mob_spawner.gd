extends Node3D

signal mob_spawned(mob: Node)

@export var spawn_scene: PackedScene = null
@export var spawn_interval: int = 2

@onready var marker_3d: Marker3D = %Marker3D
@onready var timer: Timer = %Timer
@onready var player = get_node("/root/Game/Player")
@onready var mesh_instance_3d: MeshInstance3D = %MeshInstance3D

@export var health = 100


func _ready() -> void:
	timer.wait_time = spawn_interval
	%ProgressBar.max_value = health
	%ProgressBar.value = health
	mesh_instance_3d.visible = false
	
func _process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	mesh_instance_3d.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + PI
	
func _on_timer_timeout() -> void:
	var new_mob = spawn_scene.instantiate()
	var root = get_node("/root/Game")
	root.add_child(new_mob)
	new_mob.global_position = marker_3d.global_position
	mob_spawned.emit(new_mob)

func _on_area_3d_body_entered(body: Node3D) -> void:
	mesh_instance_3d.visible = true
	timer.start()
	_on_timer_timeout()

func _on_area_3d_body_exited(body: Node3D) -> void:
	mesh_instance_3d.visible = false
	timer.stop()

func take_damage() -> void:
	const SMOKE_PUFF = preload("res://mob/smoke_puff/smoke_puff.tscn")
	health -= 4
	%ProgressBar.value = health
	$HurtAudio.play()
	if health <= 0:
		var puff = SMOKE_PUFF.instantiate()
		var root = get_node("/root/Game")
		root.add_child(puff)
		puff.global_position = $spawner_model.global_position
		queue_free()
