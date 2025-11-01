extends Area2D
class_name RoomExit

@export_dir var next_room_path: String
@export var enterance_direction: Direction
@export var door_ID: ID

var suitable_door_found: bool = false
var can_enter: bool = true

enum ID {
	A = 0,
	B = 1,
	C = 2,
	D = 4
}

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
	body_exited.connect(_on_exit)
	RoomTransition.enabled = false
	suitable_door_found = false

func _on_enter(_player: Node2D) -> void:
	if !can_enter:
		return
	var exit_scene: Node = load(next_room_path).instantiate()
	var spawn_location: Vector2
	var exit_scene_first_child: Node = exit_scene.get_child(0)
	for child in exit_scene_first_child.get_children():
		# Check if the child's class is RoomExit and check if the two rooms ID's are same
		if child is RoomExit and child.door_ID == door_ID:
			spawn_location = child.get_child(0).global_position
			suitable_door_found = true
			print(child.can_enter)
			child.can_enter = false
	if suitable_door_found == false:
		push_error("No spawn location found, defaulting to 0, 0")
		spawn_location = Vector2.ZERO
	
	RoomHandler.instance._set_current_room(exit_scene, spawn_location)
	RoomTransition.enabled = true

func _on_exit(_player: Node2D) -> void:
	can_enter = true
