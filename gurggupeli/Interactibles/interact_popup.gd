extends Control

@export var picture: Texture2D

func _ready() -> void:
	$PanelContainer/MarginContainer/HBoxContainer/TextureRect.texture = picture
