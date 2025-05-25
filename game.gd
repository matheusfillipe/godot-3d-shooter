extends Node3D
var score = 0
@onready var label: Label = %Label
var interface: XRInterface

func _ready() -> void:
	interface = XRServer.find_interface("OpenXR")
	if interface and interface.is_initialized():
		print("VR context available")
		get_viewport().use_xr = true

func increase_score() -> void:
	score += 1
	label.text = "Score: " + str(score)
	
func do_puff(mob: Node) -> void:
	const SMOKE_PUFF = preload("res://mob/smoke_puff/smoke_puff.tscn")
	var smoke = SMOKE_PUFF.instantiate()
	add_child(smoke)
	smoke.global_position = mob.global_position

func _on_mob_spawner_mob_spawned(mob: Node) -> void:
	mob.died.connect(increase_score)
	mob.freed.connect(do_puff)
	do_puff(mob)

func _on_kill_plane_body_entered(body: Node3D) -> void:
	get_tree().reload_current_scene.call_deferred()


func _on_player_died() -> void:
	get_tree().reload_current_scene.call_deferred()
