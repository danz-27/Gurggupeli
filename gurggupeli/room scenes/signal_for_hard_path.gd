extends Node2D

signal activate
signal deactivate

func _activate() -> void:
	emit_signal("activate")

func _deactivate() -> void:
	emit_signal("deactivate")
