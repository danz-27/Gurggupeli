extends Control
class_name LoadingScreen

static var instance: LoadingScreen
static var enabled: bool = false
static var fade_completed: bool = false

@onready var loading_screen: TextureRect = $TextureRect

func _ready() -> void:
	instance = self

var show_loading: bool = false
var coefficient: float = 0.1

var first_time: bool = true
var min_fade_duration: int = 20

var last_activated: int

func _physics_process(_delta: float) -> void:
	if enabled and first_time:
		last_activated = GameTime.current_time
		print(last_activated)
		show_loading = true
		first_time = false
	
	if last_activated + min_fade_duration == GameTime.current_time:
		print("tottakaj")
		first_time = true
		show_loading = false
	
	if show_loading or enabled:
		if loading_screen.modulate.a < 1:
			loading_screen.modulate.a += min_fade_duration / 100.0
		if loading_screen.modulate.a >= 1:
			fade_completed = true
	else:
		if loading_screen.modulate.a > 0:
			loading_screen.modulate.a -= min_fade_duration / 100.0
	
