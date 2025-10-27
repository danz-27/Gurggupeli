extends Control
class_name LoadingScreen

static var instance: LoadingScreen
static var enabled: bool = false
#static var fade_completed: bool = false

@onready var loading_screen: TextureRect = $TextureRect

func _ready() -> void:
	instance = self

var show_loading: bool = false
var coefficient: float = 0.1

var first_time: bool = true
var min_fade_duration: int = 25
var last_activated: int
var fade_complete: bool = true
var first_time_fade_complete: bool = true

func _physics_process(_delta: float) -> void:
	if enabled and first_time:
		last_activated = GameTime.current_time
		show_loading = true
		first_time = false
	
	if last_activated + min_fade_duration == GameTime.current_time:
		first_time = true
		show_loading = false
	
	if show_loading or enabled:
		if loading_screen.modulate.a < 1:
			loading_screen.modulate.a += 0.08
		elif loading_screen.modulate.a >= 1 and first_time_fade_complete:
			fade_complete = true
			first_time_fade_complete = false
	
	else:
		if loading_screen.modulate.a > 0:
			loading_screen.modulate.a -= 0.08
		elif loading_screen.modulate.a <= 0:
			fade_complete = false
			first_time_fade_complete = true
