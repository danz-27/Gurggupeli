extends Sprite2D

func _activate() -> void:
	$AnimationPlayer.play("ma pipe leakin")
	
func _deactivate() -> void:
	$AnimationPlayer.play("RESET")
