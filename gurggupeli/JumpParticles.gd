extends GPUParticles2D

func _physics_process(_delta: float) -> void:
	global_position = Player.instance.global_position + Vector2(0, 3)

func _on_player_just_jumped() -> void:
	spawn_particles()

func spawn_particles() -> void:
	get_process_material().set_direction(Vector3(Player.instance.velocity.x,Player.instance.velocity.y,0))
	get_process_material().set_param_max(0, 0 + 60 * Player.instance.velocity.length()/250)
	get_process_material().set_param_min(0, 0 + 20 * Player.instance.velocity.length()/250)
	emitting = true
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	emitting = false
