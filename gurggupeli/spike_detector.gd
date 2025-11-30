extends Area2D

@onready var parent: CharacterBody2D = get_parent()
@onready var hit_particles: GPUParticles2D = $"../HitParticles"

func _spike_hit(_body: Node2D) -> void:
	if parent is Player:
		parent._take_damage(1, true)
		hit_particles.emitting = true
	elif parent.has_method("_die"):
		parent._die()
	else:
		push_error("something hit the spikes but nothing was done?")
