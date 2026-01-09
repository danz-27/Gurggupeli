extends Control
class_name RoomTransition

static var instance: RoomTransition
static var enabled: bool = false
static var fade_complete: bool = false
static var first_time_fade_complete: bool = true

@onready var room_transition: TextureRect = $TextureRect

func _ready() -> void:
	instance = self

var show_loading: bool = false
var coefficient: float = 0.1
var maximium_duration: int = 0
var first_time: bool = true
var min_fade_duration: int = 25
var last_activated: int


func _physics_process(_delta: float) -> void:
	# Always keep the loading screen for the minimun amount of time
	if enabled and first_time:
		last_activated = GameTime.current_time
		show_loading = true
		first_time = false
	if last_activated + min_fade_duration == GameTime.current_time:
		first_time = true
		show_loading = false
	
	# Either show the screen or disable it in false
	if show_loading or enabled:
		if room_transition.modulate.a < 1:
			room_transition.modulate.a += 0.08
		elif room_transition.modulate.a >= 1 and first_time_fade_complete:
			fade_complete = true
			first_time_fade_complete = false
	
	else:
		if room_transition.modulate.a > 0:
			room_transition.modulate.a -= 0.08
		elif room_transition.modulate.a <= 0:
			fade_complete = false
			first_time_fade_complete = true
	
	# a failsafe 
	if enabled:
		maximium_duration += 1
		if maximium_duration >= 120:
			enabled = false
			maximium_duration = 0
			push_error("loading Screen took over 2 seconds to load")
