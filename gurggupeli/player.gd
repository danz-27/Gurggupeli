extends Node2D

@onready var gala: Sprite2D = $Gala


func _physics_process(_delta: float) -> void:
	move_and_collide()
