extends Node2D
var heal_timer: int = 0

func _physics_process(_delta: float) -> void:
	if $Area2D.has_overlapping_bodies():
		for body: Node in $Area2D.get_overlapping_bodies():
			if body is Player and heal_timer <= 0:
				body.health.health += 1
				get_tree().call_group("healthvile", "fill_vile")
				heal_timer = 20
	if heal_timer != 0:
		heal_timer -= 1
