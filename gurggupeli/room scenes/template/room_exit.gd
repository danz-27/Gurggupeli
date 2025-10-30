extends Area2D
class_name RoomExit

@export_dir var next_room_path: String
@export var enterance_direction: Direction

enum Direction {
	RIGHT = 0,
	UP = 1,
	LEFT = 2,
	DOWN = 3
}

const enterance_vectors: Dictionary[Direction, Vector2] = {
	Direction.RIGHT: Vector2.RIGHT,
	Direction.UP: Vector2.UP,
	Direction.LEFT: Vector2.LEFT,
	Direction.DOWN: Vector2.DOWN
	
}

func _ready() -> void:
	body_entered.connect(_on_enter)
	RoomTransition.enabled = false

func _on_enter(_player: Node2D) -> void:
	var exit_scene: Node = load(next_room_path).instantiate()
	var spawn_location: Vector2
	for child in exit_scene.get_children():
		# Check if the child's class is RoomExit and check if the two room's paths are linked to each other
		if child is RoomExit and exit_scene.next_room_path == get_parent().scene_file_path:
			spawn_location = child.get_child(0).position
	
	RoomHandler.instance._set_current_room(exit_scene, spawn_location)
