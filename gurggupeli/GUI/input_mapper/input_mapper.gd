extends Control

const keymaps_path: String = "user://keymaps.dat"
var keymaps: Dictionary

func _ready() -> void:
	for action in InputMap.get_actions():
		if InputMap.action_get_events(action).size() != 0:
			keymaps[action] = InputMap.action_get_events(action)[0]
	load_keymap()
	for child: Button in get_children():
		if child.has_method("update_text"):
			child.update_text()

func load_keymap() -> void:
	if not FileAccess.file_exists(keymaps_path):
		save_keymap()
		return
	var file: FileAccess = FileAccess.open(keymaps_path, FileAccess.READ)
	var temp_keymap: Dictionary = file.get_var(true) as Dictionary
	file.close()
	
	for action: String in keymaps.keys():
		if temp_keymap.has(action):
			keymaps[action] = temp_keymap[action]
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, keymaps[action])
			
func save_keymap() -> void:
	var file: FileAccess = FileAccess.open(keymaps_path, FileAccess.WRITE)
	file.store_var(keymaps, true)
	file.close()

func _on_back_button_pressed() -> void:
	hide()
	for child in $"../OptionsMenu".get_children():
		child.show()
