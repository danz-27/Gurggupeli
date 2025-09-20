extends Area2D
class_name EntityHealth

@export var health := 5
@export var iframes_duration := 1.0

@onready var iframes_timer : Timer = $Iframes

func take_damage(damage: float) -> void:
	if !iframes_timer.is_stopped():
		return
	health -= damage
	iframes_timer.start(iframes_duration)
	print(health)
