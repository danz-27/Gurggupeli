extends Node2D

func spawn_water_particles() -> void:
	var particle_instance: Node = preload("res://water_particle_system.tscn").instantiate()
	get_tree().current_scene.add_child(particle_instance)
	particle_instance.global_position = get_parent().global_position
