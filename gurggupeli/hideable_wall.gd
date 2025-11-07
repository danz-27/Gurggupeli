extends Node2D

var is_hidden: bool = false
var tile_positions: Array = []
		
func _physics_process(_delta: float) -> void:
	if is_hidden:
		if modulate.a > 0:
			modulate.a -= 0.01
	else:
		if modulate.a < 1:
			modulate.a += 0.01
	if $Area2D.has_overlapping_bodies():
		is_hidden = true
	else:
		is_hidden = false
