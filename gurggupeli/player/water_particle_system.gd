extends GPUParticles2D

@onready var water_particle_system := $WaterParticleSystem
var was_in_water_last_frame := false

func _physics_process(_delta: float) -> void:
	
	position = Player.instance.position
	#check if particles should be emitted
	if !was_in_water_last_frame and Player.instance.is_in_water():
		play_water_enter_particles()
	elif was_in_water_last_frame and !Player.instance.is_in_water():
		play_water_exit_particles()
	else:
		stop_water_particles()
		
		#set variables for next frame
	if Player.instance.is_in_water():
		was_in_water_last_frame = true
	else:
		was_in_water_last_frame = false

func play_water_enter_particles() -> void:
	get_process_material().set_direction(Vector3(-Player.instance.velocity.x,-Player.instance.velocity.y,0))
	get_process_material().set_param_max(0, 20 + Player.instance.velocity.length())
	get_process_material().set_param_min(0, 20 + Player.instance.velocity.length() - 10.0)
	emitting = true
	
func play_water_exit_particles() -> void:
	get_process_material().set_direction(Vector3(Player.instance.velocity.x,Player.instance.velocity.y,0))
	get_process_material().set_param_max(0, 20 + Player.instance.velocity.length())
	get_process_material().set_param_min(0, 20 + Player.instance.velocity.length() - 10.0)
	emitting = true

func stop_water_particles() -> void:
	emitting = false
	
