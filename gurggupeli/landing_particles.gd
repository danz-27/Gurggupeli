extends Node2D

@onready var left_particles := $LandParticlesLeft
@onready var right_particles := $LandParticlesRight

func _physics_process(_delta: float) -> void:
	left_particles.position = Player.instance.position + Vector2(0, 2)
	right_particles.position = Player.instance.position + Vector2(0, 2)
	if Player.instance.first_time_on_ground:
		left_particles.emitting = true
		right_particles.emitting = true
		await get_tree().physics_frame
		await get_tree().physics_frame
		await get_tree().physics_frame
		left_particles.emitting = false
		right_particles.emitting = false
