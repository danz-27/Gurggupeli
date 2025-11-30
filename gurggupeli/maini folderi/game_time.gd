extends Node2D
class_name GameTime

static var current_time : int = 0

func _physics_process(_delta: float) -> void:
	current_time += 1

#static func freeze_game(duration):
	#await(get_tree().create_timer(duration, true, false, true).timeout)
