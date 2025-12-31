extends Node2D

signal activate
signal deactivate

func _activate() -> void:
	emit_signal("activate")
	$"../InteractPopup/Label".set_text("DISABLE HARD MODE")
func _deactivate() -> void:
	emit_signal("deactivate")
	$"../InteractPopup/Label".set_text("ENABLE HARD MODE")
