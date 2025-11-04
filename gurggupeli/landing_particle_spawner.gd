extends Node2D

var first_time_triggering: bool = false
var particle_amount: int = 10
var saved_position: Vector2

func _physics_process(_delta: float) -> void:
	if Player.instance.is_on_floor() and first_time_triggering:
		saved_position = Player.instance.position
		spawn_particles(particle_amount)
		first_time_triggering = false
	
	if !Player.instance.is_on_floor():
		first_time_triggering = true
		
func instantiate_particles(spawn_position: Vector2) -> void:
	var scene_instance: Node = preload("res://landing_particle_animation.tscn").instantiate()
	get_tree().current_scene.add_child(scene_instance)
	scene_instance.position = spawn_position + Vector2(randi_range(-1,1), randf_range(4.5,3.5))

func spawn_particles(amount: int) -> void:
	for particle in amount:
			instantiate_particles(saved_position)
			await get_tree().physics_frame
