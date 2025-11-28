extends Area2D

@onready var parent: CharacterBody2D = get_parent()

func _physics_process(_delta: float) -> void:
	var overlapping_bodies: Array[Node2D] = get_overlapping_bodies()
	
	for area in overlapping_bodies:
		if parent is Player:
			parent._take_damage()
		elif parent.has_method("_die"):
			parent._die()
		else:
			push_error("something hit the spikes but nothing was done?")
