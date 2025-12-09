extends Area2D
class_name RoomExit

@export_dir var next_room_path: String
@export var enterance_direction: Direction
@export var door_ID: ID
#@onready var door_collision: CollisionShape2D = $CollisionShape2D

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
	Direction.RIGHT: Vector2.LEFT,
	Direction.UP: Vector2.DOWN,
	Direction.LEFT: Vector2.RIGHT,
	Direction.DOWN: Vector2.UP
}

func _ready() -> void:
	body_entered.connect(_on_enter)
	suitable_door_found = false

func _on_enter(player: Node2D) -> void:
	var spawn_location: Vector2
	
	while overlaps_body(player):
		if RoomTransition.enabled:
			RoomTransition.enabled = false
		
		if Input.get_vector("move_left", "move_right", "move_up", "move_down") == enterance_vectors[enterance_direction]:
			var exit_scene: Node = load(next_room_path).instantiate()
			var exit_scene_first_child: Node = exit_scene.get_child(0)
			for child: Node in exit_scene_first_child.get_children():
				# Check if the child's class is RoomExit and check if the two rooms ID's are same
				if child is RoomExit and child.door_ID == door_ID:
					spawn_location = child.get_child(0).global_position
					suitable_door_found = true
					RoomTransition.enabled = true
					while !RoomTransition.fade_complete:
						await get_tree().physics_frame
					RoomHandler.instance._change_room(exit_scene, spawn_location)
					Player.instance.respawn_pos = child.get_child(1).global_position
					
				await get_tree().physics_frame
			
			if suitable_door_found == false:
				push_error("No spawn location found, defaulting to 0, 0")
				spawn_location = Vector2.ZERO
		
			
		await get_tree().physics_frame
