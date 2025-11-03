extends TileMapLayer

var LightFlickerTimers: Dictionary = {}

func flicker(light: Light2D) -> void:
	var SaveEnergy: float = light.energy
	var flicker_timer: int = randi_range(3, 15)
	light.energy = 1
	for i in range(flicker_timer):
		await get_tree().physics_frame
	light.energy = SaveEnergy

func _ready() -> void:
	for child in get_children():
		if child is Light2D:
			LightFlickerTimers[child] = randi_range(0, 1000)
	
func _physics_process(_delta: float) -> void:
	for light: Light2D in LightFlickerTimers:
		if LightFlickerTimers[light] == 0:
			flicker(light)
			LightFlickerTimers[light] = randi_range(500, 2000)
		else:
			LightFlickerTimers[light] = LightFlickerTimers[light]-1
