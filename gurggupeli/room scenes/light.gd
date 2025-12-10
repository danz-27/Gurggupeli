extends PointLight2D

var flicking_interval: int = randi_range(0, 2000)
@export var flickers: bool = true
@export var is_fire: bool = false

@export_category("Colours")
@export var is_electiric: bool
@export var is_natural: bool
@export var custom_colour: bool = false

var brightness_range: float = randf_range(0.4, 0.6)
var min_brightness: float = energy - brightness_range
var max_brightness: float = energy + brightness_range
var brightening_speed: float = randf_range(0.005, 0.007)
var brightening: bool = false

func _ready() -> void:
	if !custom_colour:
		if is_electiric:
			color = Color(1.0, 0.894, 0.647)
		if is_natural:
			color = Color(1.0, 0.835, 0.435)
	energy = randf_range(min_brightness, max_brightness)

func flicker() -> void:
	var SaveEnergy: float = energy
	var flicker_timer: int = randi_range(3, 15)
	energy = 1
	for i in range(flicker_timer):
		await get_tree().physics_frame
	energy = SaveEnergy
	
func _physics_process(_delta: float) -> void:
	if flickers:
		if flicking_interval == 0:
			flicker()
			flicking_interval = randi_range(500, 2000)
		else:
			flicking_interval -= 1
	if is_fire:
		if !brightening:
			energy -= brightening_speed
			texture_scale -= brightening_speed
			if energy <= min_brightness:
				brightening = true
		else:
			energy += brightening_speed
			texture_scale += brightening_speed
			if energy >= max_brightness:
				brightening = false
