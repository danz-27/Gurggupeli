extends Area2D

func _physics_process(_delta: float) -> void:
	var overlapping_areas: Array[Node2D] = get_overlapping_bodies()
	print(overlapping_areas)
	for area in overlapping_areas:
		#if area.has_method("_die"):
		get_parent()._die()
