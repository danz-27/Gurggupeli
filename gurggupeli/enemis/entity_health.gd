extends Area2D
class_name EntityHealth

@export var health := 5
@export var iframes_duration := 1

@onready var iframes_timer : Timer = $Iframes

func take_damage(damage: int) -> void:
	if !iframes_timer.is_stopped():
		return
	health -= damage
	$"../HitParticles".emitting = true
	GameTime.instance.freeze_game(0.08)
	iframes_timer.start(iframes_duration)
	if health <= 0:
		get_parent()._die()
