extends Label

func _physics_process(_delta: float) -> void:
	text = InputMap.action_get_events("interact")[0].as_text()
