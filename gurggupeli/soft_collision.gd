extends Area2D
class_name SoftCollision

@export var push_force: float = 5.0

func _physics_process(_delta: float) -> void:
	for area: Area2D in get_overlapping_areas():
		if area is SoftCollision:
			get_parent().velocity += area.global_position.direction_to(global_position) * push_force
			area.get_parent().velocity += global_position.direction_to(area.global_position) * push_force
