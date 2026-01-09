extends TextureRect
class_name OptionsMenu

static var instance: OptionsMenu

@onready var BG: TextureRect = $BG
@onready var BG2: TextureRect = $BG2

var temp: Array
var pause_screen: PauseScreen
var bg_speed: float = 0.05
var is_on_pause_menu: bool = false
var texture_width: int = 324
var show_debug: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	temp = get_parent().get_children().filter(func(node: Node) -> bool: return node is PauseScreen)
	pause_screen = temp[0]
	instance = self
	BG.global_position.x = 0
	BG2.global_position.x = texture_width

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	BG.global_position.x -= bg_speed
	BG2.global_position.x -= bg_speed
	if BG.global_position.x <= -texture_width:
		BG.global_position.x = abs(BG.global_position.x)
	if BG2.global_position.x <= -texture_width:
		BG2.global_position.x = abs(BG2.global_position.x)
	
	if Input.is_action_just_pressed("ui_text_delete"):
		$VBoxContainer/MusicVolumeButton.show()
		show_debug = true
		
	
	if Player.instance.debug_mode_active:
		$VBoxContainer/MusicVolumeButton.show()
	elif !show_debug:
		$VBoxContainer/MusicVolumeButton.hide()

func _on_key_bind_button_pressed() -> void:
	$VBoxContainer/KeyBindButton.hide()
	$VBoxContainer/MusicVolumeButton.hide()
	$VBoxContainer/BackButton.hide()
	
	$"../InputMapper".show()
	

func _on_music_volume_button_pressed() -> void:
	$VBoxContainer/KeyBindButton.hide()
	$VBoxContainer/MusicVolumeButton.hide()
	$VBoxContainer/BackButton.hide()
	
	$"../DebugMenu".show()

func _on_back_button_pressed() -> void:
	visible = false
	show_debug = false
	$VBoxContainer/MusicVolumeButton.hide()
	#print(PauseScreen.instance)
	if is_on_pause_menu:
		pause_screen.visible = true
		#print(pause_screen)
