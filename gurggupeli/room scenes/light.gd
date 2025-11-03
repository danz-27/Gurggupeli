extends PointLight2D

var flicking_interval: int = randi_range(0, 2000)

func flicker() -> void:
	var SaveEnergy: float = energy
	var flicker_timer: int = randi_range(3, 15)
	energy = 1
	for i in range(flicker_timer):
		await get_tree().physics_frame
	energy = SaveEnergy
	
func _physics_process(_delta: float) -> void:
	if flicking_interval == 0:
		flicker()
		flicking_interval = randi_range(500, 2000)
	else:
		flicking_interval -= 1
