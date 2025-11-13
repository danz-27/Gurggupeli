extends Label

func _physics_process(_delta: float) -> void:
	text = str(get_parent().class_pipe_instance.get_pipe_hole_directions(), "\n", get_parent().position_in_array)
