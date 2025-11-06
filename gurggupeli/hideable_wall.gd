extends Node2D

var is_hidden: bool = false
var tile_positions: Array = []

func _activate() -> void:
	is_hidden = true
		
func _physics_process(_delta: float) -> void:
	if is_hidden:
		if modulate.a > 0:
			modulate.a -= 0.01
