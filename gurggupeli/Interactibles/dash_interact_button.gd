extends Label

func _physics_process(_delta: float) -> void:
	text = "Press " + InputMap.action_get_events("dash")[0].as_text() + " to dash"
