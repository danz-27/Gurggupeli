extends Node2D

@onready var left_particles := $LandParticlesLeft
@onready var right_particles := $LandParticlesRight
var first_time_triggering: bool = false

func _physics_process(_delta: float) -> void:
	if Player.instance.is_on_floor() and first_time_triggering:
		left_particles.position = Player.instance.position + Vector2(-8, 6)
		right_particles.position = Player.instance.position + Vector2(8, 6)
		left_particles.emitting = true
		right_particles.emitting = true
		await get_tree().physics_frame
		await get_tree().physics_frame
		await get_tree().physics_frame
		left_particles.emitting = false
		right_particles.emitting = false
		first_time_triggering = false
	
	if !Player.instance.is_on_floor():
		first_time_triggering = true
