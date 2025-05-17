extends Node3D

signal mob_spawned(mob: Node)

@export var spawn_scene: PackedScene = null
@export var spawn_interval: int = 2

@onready var marker_3d: Marker3D = %Marker3D
@onready var timer: Timer = %Timer

func _ready() -> void:
	timer.wait_time = spawn_interval
	
func _on_timer_timeout() -> void:
	var new_mob = spawn_scene.instantiate()
	add_child(new_mob)
	new_mob.global_position = marker_3d.global_position
	mob_spawned.emit(new_mob)


func _on_area_3d_body_entered(body: Node3D) -> void:
	timer.start()
	_on_timer_timeout()

func _on_area_3d_body_exited(body: Node3D) -> void:
	timer.stop()
