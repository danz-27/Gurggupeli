extends Area2D

@export_dir var room_path: String
@export var spawn_location: Vector2

func _ready() -> void:
	body_entered.connect(_on_enter)

func _on_enter(_player: Node2D) -> void:
	var exit_scene: Resource = load(room_path)
	RoomHandler.instance._set_current_room(exit_scene, spawn_location)
