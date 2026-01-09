extends TileMapLayer

@export var is_hard_part: bool = false

func _on_signal_for_hard_path_activate() -> void:
	if is_hard_part:
		enabled = true
	else:
		enabled = false


func _on_signal_for_hard_path_deactivate() -> void:
	if is_hard_part:
		enabled = false
	else:
		enabled = true
