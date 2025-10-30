extends GPUParticles2D

var was_in_water_last_frame := false

func _physics_process(_delta: float) -> void:
	
	position = Player.instance.position + Vector2(0, 2)
	#check if particles should be emitted
	if !was_in_water_last_frame and Player.instance.is_in_water():
		play_water_enter_particles()
	elif was_in_water_last_frame and !Player.instance.is_in_water():
		play_water_exit_particles()
		
		#set variables for next frame
	if Player.instance.is_in_water():
		was_in_water_last_frame = true
	else:
		was_in_water_last_frame = false

func play_water_enter_particles() -> void:
	get_process_material().set_direction(Vector3(-Player.instance.velocity.x,-Player.instance.velocity.y,0))
	get_process_material().set_param_max(0, 35 + 60 * Player.instance.velocity.length()/250)
	get_process_material().set_param_min(0, 25 + 20 * Player.instance.velocity.length()/250)
	emitting = true
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	emitting = false
	
func play_water_exit_particles() -> void:
	get_process_material().set_direction(Vector3(Player.instance.velocity.x,Player.instance.velocity.y,0))
	get_process_material().set_param_max(0, 35 + 60 * Player.instance.velocity.length()/250)
	get_process_material().set_param_min(0, 25 + 20 * Player.instance.velocity.length()/250)
	emitting = true
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	emitting = false
	
