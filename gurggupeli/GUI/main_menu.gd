extends Control
class_name MainMenu

static var instance: MainMenu

@onready var BG: TextureRect = $BG
@onready var BG2: TextureRect = $BG2
var speed: float = 0.05
var texture_width: int = 324

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	BG.global_position.x = 0
	BG2.global_position.x = texture_width


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	BG.global_position.x -= speed
	BG2.global_position.x -= speed
	if BG.global_position.x <= -texture_width:
		BG.global_position.x = abs(BG.global_position.x)
	if BG2.global_position.x <= -texture_width:
		BG2.global_position.x = abs(BG2.global_position.x)
	
	if visible:
		get_tree().paused = true
	elif !get_tree().is_paused:
		get_tree().paused = false


func _on_play_button_pressed() -> void:
	visible = false
	OptionsMenu.instance.is_on_pause_menu = true


func _on_options_button_pressed() -> void:
	OptionsMenu.instance.is_on_pause_menu = false
	OptionsMenu.instance.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()
