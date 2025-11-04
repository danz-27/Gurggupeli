extends CharacterBody2D
class_name Entity

enum TEAM {
	PLAYER,
	ENEMY
}

@export var team : TEAM = TEAM.ENEMY

func _die() -> void:
	get_parent().queue_free()
