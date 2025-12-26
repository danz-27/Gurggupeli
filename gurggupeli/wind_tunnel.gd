extends Node2D

@export var acceleration_per_frame: float
@export var direction: Vector2
var activated: bool = true

func _ready() -> void:
	$GPUParticles2D.get_process_material().set_param_max(0, acceleration_per_frame)
	$GPUParticles2D.get_process_material().set_param_min(0, acceleration_per_frame)
	$GPUParticles2D.get_process_material().set_direction(Vector3(direction.x, direction.y, 0))
	$GPUParticles2D.get_process_material().set_emission_box_extents(Vector3($Area2D/CollisionShape2D.shape.size.x/2, $Area2D/CollisionShape2D.shape.size.y/2, 0))
	print($Area2D/CollisionShape2D.shape.size.x/2, $Area2D/CollisionShape2D.shape.size.y/2)

func _physics_process(_delta: float) -> void:
	if activated:
		for body: Entity in $Area2D.get_overlapping_bodies():
			print(body.velocity)
			body.velocity += direction * acceleration_per_frame

func _activate() -> void:
	activated = false
	$GPUParticles2D.emitting = false
	
func _deactivate() -> void:
	activated = true
	$GPUParticles2D.emitting = true
