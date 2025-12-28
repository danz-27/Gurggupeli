extends Area2D
class_name EntityHealth

@export var health := 5
@export var iframes_duration: float = 1.0

@onready var iframes_timer : Timer = $Iframes

var invincible: bool = false

func take_damage(damage: int) -> void:
	if invincible:
		return
	if !iframes_timer.is_stopped():
		return
	health -= damage
	if get_node_or_null("../HitParticles"):
		$"../HitParticles".emitting = true
	GameTime.instance.freeze_game(0.08)
	iframes_timer.start(iframes_duration)
	if health <= 0:
		get_parent()._die()

func make_invincible() -> void:
	invincible = true

func make_vincible() -> void:
	invincible = false
