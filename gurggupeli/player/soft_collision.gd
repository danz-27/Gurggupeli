extends Area2D
class_name SoftCollision

@export var push_force: float = 5.0
@export var automatically_apply: bool = true
static var velocity_to_add: Vector2

func _physics_process(_delta: float) -> void:
	if automatically_apply:
		for area: Area2D in get_overlapping_areas():
			if area is SoftCollision:
				if area.automatically_apply:
					get_parent().velocity += area.global_position.direction_to(global_position) * push_force
	else:
		for area: Area2D in get_overlapping_areas():
			if area is SoftCollision:
				velocity_to_add += area.global_position.direction_to(global_position) * area.push_force
