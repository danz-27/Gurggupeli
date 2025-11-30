extends GPUParticles2D

@export var particle_color: Color

func _ready() -> void:
	modulate = particle_color
	
