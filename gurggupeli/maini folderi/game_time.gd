extends Node2D
class_name GameTime

static var current_time : int = 0
static var instance: GameTime

func _ready() -> void:
	instance = self

func _physics_process(_delta: float) -> void:
	current_time += 1

func freeze_game(duration: float) -> void:
	Engine.time_scale = 0
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1
