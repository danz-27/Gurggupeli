extends Node2D

@export var right_entrance_direction: Direction
@export var up_entrance_direction: Direction
@export var left_entrance_direction: Direction
@export var down_entrance_direction: Direction

@onready var intersection: Area2D = $Intersection
@onready var right_area: Area2D = $RightEntrance
@onready var up_area: Area2D = $UpEntrance
@onready var left_area: Area2D = $LeftEntrance
@onready var down_area: Area2D = $DownEntrance

@onready var right_entrance: CollisionShape2D = $RightEntrance/CollisionShape2D
@onready var up_entrance: CollisionShape2D = $UpEntrance/CollisionShape2D
@onready var left_entrance: CollisionShape2D = $LeftEntrance/CollisionShape2D
@onready var down_entrance: CollisionShape2D = $DownEntrance/CollisionShape2D

@onready var right_entrance_path: PathFollow2D = $RightEntrance/Path2D/PathFollow2D
@onready var up_entrance_path: PathFollow2D = $UpEntrance/Path2D/PathFollow2D
@onready var left_entrance_path: PathFollow2D = $LeftEntrance/Path2D/PathFollow2D
@onready var down_entrance_path: PathFollow2D = $DownEntrance/Path2D/PathFollow2D

var default_exit_dir: Direction = Direction.NONE
var default_exit_area: Area2D
var default_path: PathFollow2D

enum Direction {
	NONE = -1,
	RIGHT = 0,
	UP = 1,
	LEFT = 2,
	DOWN = 3
}

var vector_to_dir: Dictionary[Vector2i, Direction] = {
	Vector2i.RIGHT: Direction.RIGHT,
	Vector2i.UP: Direction.UP,
	Vector2i.LEFT: Direction.LEFT,
	Vector2i.DOWN: Direction.DOWN
}
# Convert to string for handling the directions between scenes
var dir_to_string: Dictionary[Direction, String] = {
	 Direction.RIGHT: "RIGHT",
	Direction.UP: "UP", 
	Direction.LEFT: "LEFT",
	Direction.DOWN: "DOWN"
}

var allowed_exits: Dictionary[Vector2, Direction] = {
	Vector2(1.0, 0.0): right_entrance_direction,
	Vector2.UP: up_entrance_direction,
	Vector2.LEFT: left_entrance_direction,
	Vector2.DOWN: down_entrance_direction
}

# change the area2D to path2d once implemented
var exit_path: Dictionary[Direction, CollisionShape2D] = {}

func _ready() -> void:
	exit_path[Direction.RIGHT] = right_entrance
	exit_path[Direction.UP] = up_entrance
	exit_path[Direction.LEFT] = left_entrance
	exit_path[Direction.DOWN] = down_entrance

func _on_intersection_entered(player: Node2D) -> void:
	if default_exit_dir == Direction.NONE:
		return
	
	var input_vector: Vector2i = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# Check if nothing was pressed when entering, to just go to the default exit
	if input_vector == Vector2i.ZERO:
		move_from_intersection(player, default_exit_area, default_path)
		return
	
	# Turn the input_vector into a Direction
	var input_direction: Direction = vector_to_dir[input_vector]
	
	# Check forward
	if input_direction == default_exit_dir:
		player.position = check_if_direction_exists_default(default_exit_dir)
	# Check right
	elif input_direction == (default_exit_dir + 1) % 4:
		player.position = check_if_direction_exists_right((default_exit_dir + 1) % 4)
	# Check left
	else:
		player.position = check_if_direction_exists_left((default_exit_dir + 3) % 4)


func _on_right_entrance_body_entered(player: Node2D) -> void:
	default_exit_dir = Direction.LEFT
	default_exit_area = right_area
	default_path = right_entrance_path
	Pipe.instance._on_head_1_entered(
		player,
		right_area,
		intersection,
		Pipe.Direction[dir_to_string[(right_entrance_direction + 2) % 4]], 
		Pipe.Direction[dir_to_string[default_exit_dir]], 
		right_entrance_path
	)

func _on_up_entrance_body_entered(player: Node2D) -> void:
	default_exit_dir = Direction.DOWN
	default_exit_area = up_area
	default_path = up_entrance_path
	Pipe.instance._on_head_1_entered(
		player,
		up_area,
		intersection,
		Pipe.Direction[dir_to_string[(up_entrance_direction + 2) % 4]], 
		Pipe.Direction[dir_to_string[default_exit_dir]], 
		up_entrance_path
	)

func _on_left_entrance_body_entered(player: Node2D) -> void:
	default_exit_dir = Direction.RIGHT
	default_exit_area = left_area
	default_path = left_entrance_path
	Pipe.instance._on_head_1_entered(
		player,
		left_area,
		intersection,
		Pipe.Direction[dir_to_string[(left_entrance_direction + 2) % 4]], 
		Pipe.Direction[dir_to_string[default_exit_dir]], 
		left_entrance_path
	)

func _on_down_entrance_body_entered(player: Node2D) -> void:
	default_exit_dir = Direction.UP
	default_exit_area = down_area
	default_path = down_entrance_path
	Pipe.instance._on_head_1_entered(
		player,
		down_area,
		intersection,
		Pipe.Direction[dir_to_string[(down_entrance_direction + 2) % 4]], 
		Pipe.Direction[dir_to_string[default_exit_dir]], 
		down_entrance_path
	)

func check_if_direction_exists_default(exit_dir: Direction) -> Vector2:
	if exit_dir != Direction.NONE:
		return exit_path[exit_dir].global_position
	
	# Check if intersection enterance direction +90 deg exists
	elif (exit_dir + 1) % 4 != Direction.NONE:
		return exit_path[(exit_dir + 1) % 4].global_position
	# Check if intersection enterance direction +270 deg exists
	elif (exit_dir + 3) % 4 != Direction.NONE:
		return exit_path[(exit_dir + 3) % 4].global_position
	# Return the path that the player came from if nothing else worked
	else:
		return exit_path[(exit_dir + 2) % 4].global_position
		

func check_if_direction_exists_right(exit_dir: Direction) -> Vector2:
	if exit_dir != Direction.NONE:
		return exit_path[exit_dir].global_position
	
	# Check if intersection enterance direction +90 deg exists
	elif (exit_dir + 1) % 4 != Direction.NONE:
		return exit_path[(exit_dir + 1) % 4].global_position
	# Check if intersection enterance direction +180 deg exists
	elif (exit_dir + 2) % 4 != Direction.NONE:
		return exit_path[(exit_dir + 2) % 4].global_position
	# Return the path that the player came from if nothing else worked
	else:
		return exit_path[(exit_dir + 3) % 4].global_position

func check_if_direction_exists_left(exit_dir: Direction) -> Vector2:
	if exit_dir != Direction.NONE:
		return exit_path[exit_dir].global_position
	
	# Check if intersection enterance direction +270 deg exists
	elif (exit_dir + 3) % 4 != Direction.NONE:
		return exit_path[(exit_dir + 3) % 4].global_position
	# Check if intersection enterance direction +180 deg exists
	elif (exit_dir + 2) % 4 != Direction.NONE:
		return exit_path[(exit_dir + 2) % 4].global_position
	# Return the path that the player came from if nothing else worked
	else:
		return exit_path[(exit_dir + 1) % 4].global_position


func move_from_intersection(player, head_1: Area2D, path: PathFollow2D) -> void:
	pipe_entered_velocity_length = player.velocity.length()
	var pipe_travel_speed: float = pipe_entered_velocity_length / 75.0 + 5.0
	
	path.progress_ratio = 1.0
	player.get_node("CollisionShape2D").set_deferred("disabled", true)
	player.gurggu.visible = false
	player.frozen = true
	while path.progress_ratio > 0.0:
		path.progress -= pipe_travel_speed
		player.position = path.global_position
		await get_tree().physics_frame
	
	dash_direction = Vector2.ZERO
	change_velocity(head1_direction, pipe_entered_velocity_length, player)
	
	player.get_node("CollisionShape2D").set_deferred("disabled", false)
	player.gurggu.visible = true
	player.frozen = false
	can_enter = false
	
	wait_for_release = true
	while Input.is_action_pressed(action_for_direction[head2_direction]):
		await get_tree().physics_frame
	wait_for_release = false
	return
