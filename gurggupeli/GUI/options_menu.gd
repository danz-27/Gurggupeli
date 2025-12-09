extends TextureRect
class_name OptionsMenu

static var instance: OptionsMenu

@onready var BG: Sprite2D = $BG
@onready var BG2: Sprite2D = $BG2

var temp: Array
var pause_screen: PauseScreen
var bg_speed: float = 0.05
var is_on_pause_menu: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	temp = get_parent().get_children().filter(func(node: Node) -> bool: return node is PauseScreen)
	pause_screen = temp[0]
	instance = self
	BG.position.x = 0
	BG2.position.x = 328

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	BG.position.x -= bg_speed
	BG2.position.x -= bg_speed
	if BG.position.x <= -328:
		BG.position.x = abs(BG.position.x)
	if BG2.position.x <= -328:
		BG2.position.x = abs(BG2.position.x)


func _on_key_bind_button_pressed() -> void:
	pass # Replace with function body.


func _on_music_volume_button_pressed() -> void:
	pass # Replace with function body.


func _on_back_button_pressed() -> void:
	visible = false
	#print(PauseScreen.instance)
	if is_on_pause_menu:
		pause_screen.visible = true
		print(pause_screen)
