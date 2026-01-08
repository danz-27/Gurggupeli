extends Node2D

@export_dir var boss_scene: String
var boss_spawned: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if !boss_spawned:
			if GlobalVariables.big_rat_killed:
				return
			boss_spawned = true
			var rotta: BigRat = BigRat.new()
			rotta.call_deferred("create",$"boss spawn location".global_position)
