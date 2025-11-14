extends Label

func _physics_process(_delta: float) -> void:
	text = str(get_parent().get_pipe_hole_directions(), "\n", get_parent().position_in_array)
