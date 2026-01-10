extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var main_menu: Control = $"../MainMenu"

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	visible = false
	main_menu.visible = false
	OptionsMenu.instance.is_on_pause_menu = true
