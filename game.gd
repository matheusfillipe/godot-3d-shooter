extends Node3D
var score = 0
@onready var label: Label = %Label

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
