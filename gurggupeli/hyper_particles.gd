extends GPUParticles2D

var time_between_spawns: int = 7
var time_since_last_particles: int = 0

func _physics_process(_delta: float) -> void:
	global_position = Player.instance.global_position
	if Player.instance.keep_dash_velocity:
		get_process_material().set_direction(Vector3(Player.instance.velocity.x,Player.instance.velocity.y,0))
		get_process_material().set_param_max(0, 0 + 30 * Player.instance.velocity.length()/250)
		get_process_material().set_param_min(0, 0 + 30 * Player.instance.velocity.length()/250)
		emitting = true
	else:
		emitting = false
