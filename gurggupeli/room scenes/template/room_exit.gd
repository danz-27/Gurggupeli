extends Area2D

@export_dir var next_room_path: String
@export var next_room_spawn_location: Vector2

func _ready() -> void:
	body_entered.connect(_on_enter)
	LoadingScreen.enabled = false

func _on_enter(_player: Node2D) -> void:
	var exit_scene: Resource = load(next_room_path)
	RoomHandler.instance._set_current_room(exit_scene, next_room_spawn_location)
