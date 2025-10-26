extends Control
class_name LoadingScreen

static var instance: LoadingScreen

@onready var loading_screen: TextureRect = $TextureRect

func _ready() -> void:
	instance = self


func _enable() -> void:
	if loading_screen.modulate.a > 0:
		await get_tree().physics_frame
		await get_tree().physics_frame
		await get_tree().physics_frame 
	
	
	while loading_screen.modulate.a < 1:
		loading_screen.modulate.a += 0.5
		await get_tree().physics_frame


func _disable() -> void:
	if loading_screen.modulate.a < 1:
		await get_tree().physics_frame
		await get_tree().physics_frame
		await get_tree().physics_frame 
	
	while loading_screen.modulate.a > 0:
		loading_screen.modulate.a -= 0.5
		await get_tree().physics_frame
