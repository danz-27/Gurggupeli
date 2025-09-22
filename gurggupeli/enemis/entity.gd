extends CharacterBody2D
class_name Entity


func _ready() -> void:
	pass

enum TEAM {
	PLAYER,
	ENEMY
}

@export var team : TEAM = TEAM.ENEMY

func _die() -> void:
	get_parent().queue_free()


func _process(_delta: float) -> void:
	pass
