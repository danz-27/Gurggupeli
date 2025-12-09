extends TextureRect
class_name PauseScreen

static var instance: PauseScreen

func _onready() -> void:
	instance = self


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		visible = true
		OptionsMenu.instance.is_on_pause_menu = true


func _on_continue_button_pressed() -> void:
	visible = false
	OptionsMenu.instance.is_on_pause_menu = false


func _on_options_button_pressed() -> void:
	visible = false
	OptionsMenu.instance.visible = true


func _on_exit_button_pressed() -> void:
	visible = false
	MainMenu.instance.visible = true
