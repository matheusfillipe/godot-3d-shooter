extends Node3D

@onready var animation_tree = $AnimationTree

func hurt() -> void:
	animation_tree.set("parameters/OneShot/request", true)
