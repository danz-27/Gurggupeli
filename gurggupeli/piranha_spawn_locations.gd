extends Node2D


func _ready() -> void:
	for child in get_children():
		Piranha.create(child.position)
