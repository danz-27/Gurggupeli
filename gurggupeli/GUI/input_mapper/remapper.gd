extends Button

@export var action: String
@onready var input_mapper: Control = find_parent("InputMapper")

func _init() -> void:
	toggle_mode = true

func _ready() -> void:
	set_process_unhandled_input(false)
	add_theme_color_override("font_color", Color(0.0, 0.568, 0.0, 1.0))

func _toggled(toggled_on: bool) -> void:
	set_process_unhandled_input(toggled_on)
	if toggled_on:
		text = "..."
		release_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		button_pressed = false
		release_focus()
		update_text()
		input_mapper.keymaps[action] = event
		input_mapper.save_keymap()
		
func update_text() -> void:
	text = InputMap.action_get_events(action)[0].as_text().split(" ")[0]
