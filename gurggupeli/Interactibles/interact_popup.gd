extends Control

@export var image: Texture2D

func _ready() -> void:
	if image != null:
		$PanelContainer/MarginContainer/HBoxContainer/TextureRect.texture = image
