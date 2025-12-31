extends Node2D

@export_dir var boss_scene: String

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		var boss: Node = load(boss_scene).instantiate()
		add_child(boss)
		boss.position = $"boss spawn location".position
