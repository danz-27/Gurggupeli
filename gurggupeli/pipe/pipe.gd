extends Node2D
class_name Pipe

@export var head1_direction: Direction
@export var head2_direction: Direction
@onready var head_1: Area2D = $Head1
@onready var head_2: Area2D = $Head2
@onready var path: PathFollow2D = $Path2D/PathFollow2D
@onready var points_in_path: Path2D = $Path2D

var tilemap: TileMapLayer
var wait_for_release: bool = false
var dash_direction: Vector2
var pipe_entered_velocity_length: float
var can_enter: bool = true

var last_entered: int = GameTime.current_time
var DURATION: int = 10

enum Direction {
	DOWN = 1,
	UP = 3,
	RIGHT = 0,
	LEFT = 2
}

const axis_for_direction: Dictionary[Direction, Vector2] = {
	Direction.UP: Vector2.UP,
	Direction.DOWN: Vector2.DOWN,
	Direction.LEFT: Vector2.LEFT,
	Direction.RIGHT: Vector2.RIGHT
}

const vector_for_direction: Dictionary[Direction, Vector2] = {
	Direction.UP: Vector2.DOWN,
	Direction.DOWN: Vector2.UP,
	Direction.LEFT: Vector2.RIGHT,
	Direction.RIGHT: Vector2.LEFT
}
	
func calclulate_path() -> void:
	var starting_position: Vector2 = head_1.global_position
	var ending_position: Vector2 = head_2.global_position
	#print(tilemap)
	var starting_position_in_tilemap: Vector2i = tilemap.local_to_map(starting_position)
	var current_position: Vector2 = starting_position_in_tilemap
	var direction_coming_from: int = head1_direction
	var maximum_tiles: int = 500
	var iterations: int
	var current_cell: TileData = tilemap.get_cell_tile_data(starting_position_in_tilemap)
	if !current_cell:
		return
	var directions: Array = current_cell.get_custom_data("pipe directions")
	#print(directions)
	var direction_going_to: int
	var return_other_direction: Dictionary = {
		directions[0]: directions[1],
		directions[1]: directions[0]
	}
	direction_going_to = return_other_direction[direction_coming_from]
	points_in_path.curve = points_in_path.curve.duplicate(true)
	print(points_in_path.global_position)
	points_in_path.position = Vector2i.ZERO
	points_in_path.global_position -= position
	points_in_path.curve.clear_points()
	points_in_path.curve.add_point(to_global(Vector2(starting_position)))
	print(starting_position_in_tilemap, " ", direction_coming_from)
	points_in_path.curve.add_point(to_global(Vector2(tilemap.map_to_local(current_position))))
	#current_cell.get_custom_data("pipe directions")
	#tilemap.get_neighbor_cell(current_position, direction_going_to * 4)
	iterations = 0
	while current_cell and iterations < maximum_tiles: #check if cell is empty
		if current_cell.get_custom_data("pipe directions").size() > 0:
			directions = current_cell.get_custom_data("pipe directions")
			return_other_direction = {
			directions[0]: directions[1],
			directions[1]: directions[0]
			}
		#print(directions)
		#print(current_position)
		if direction_coming_from in directions  or current_cell.get_custom_data("pipe directions").size() == 0:
			if current_cell.get_custom_data("pipe directions").size() > 0:
				direction_going_to = return_other_direction[direction_coming_from]
			current_position = tilemap.get_neighbor_cell(current_position, direction_going_to * 4)
			current_cell = tilemap.get_cell_tile_data(current_position)
			if current_cell:
				points_in_path.curve.add_point(to_global(Vector2(tilemap.map_to_local(current_position))))
				direction_coming_from = (direction_going_to + 2) % 4
		iterations += 1
	points_in_path.curve.add_point(Vector2(ending_position))
	#print(points_in_path)
	#print(points_in_path.curve.get_baked_points())

func _ready() -> void:
	print(get_parent().get_parent().name)
	if get_parent().get_parent().name == "putkilo":
		tilemap = get_parent().get_parent() as TileMapLayer
		print("tilemap: ",tilemap)
		calclulate_path()


func _physics_process(_delta: float) -> void:
	if (last_entered + DURATION == GameTime.current_time):
		can_enter = true
	#print(can_enter)
	
	if Player.instance.is_dashing():
		can_enter = true
		wait_for_release = false

func _on_head_1_entered(player: Node2D) -> void:
	last_entered = GameTime.current_time
	
	while !can_enter:
		await get_tree().physics_frame
	
	while head_1.overlaps_body(player):
		if player.is_dashing() and !(player.dash_timer.time_left >= (player.dash_duration - player.dash_buffer_time)):
			dash_direction = player.dash_direction
		else:
			dash_direction = Vector2.ZERO
		
		if !wait_for_release and Input.get_vector("move_left", "move_right", "move_up", "move_down") == vector_for_direction[head1_direction] or (dash_direction == vector_for_direction[head1_direction]):
			player.dash_timer.stop()
			player.on_dash_timer_timeout()
			pipe_entered_velocity_length = player.velocity.length()
			#print(pipe_entered_velocity_length)
			var pipe_travel_speed: float = pipe_entered_velocity_length / 75.0 + 5.0
			
			player.get_node("CollisionShape2D").set_deferred("disabled", true)
			player.gurggu.visible = false
			player.frozen = true
			player.keep_moving = false
			while path.progress_ratio < 1.0:
				path.progress += pipe_travel_speed
				player.position = path.global_position
				await get_tree().physics_frame
			
			dash_direction = Vector2.ZERO
			change_velocity(head2_direction, pipe_entered_velocity_length, player)
			
			player.get_node("CollisionShape2D").set_deferred("disabled", false)
			player.gurggu.visible = true
			player.frozen = false
			player.keep_moving = true
			can_enter = false
			
			wait_for_release = true
			while Input.get_vector("move_left", "move_right", "move_up", "move_down") == vector_for_direction[head1_direction]:
				await get_tree().physics_frame
			wait_for_release = false
			return
		await get_tree().physics_frame


func _on_head_2_entered(player: Node2D) -> void:
	path.progress_ratio = 0.0
	last_entered = GameTime.current_time
	
	while !can_enter:
		await get_tree().physics_frame
	
	while head_2.overlaps_body(player):
		if player.is_dashing() and !(player.dash_timer.time_left >= (player.dash_duration - player.dash_buffer_time)):
			dash_direction = player.dash_direction
		else:
			dash_direction = Vector2.ZERO
		
		if !wait_for_release and Input.get_vector("move_left", "move_right", "move_up", "move_down") == vector_for_direction[head2_direction] or (dash_direction == vector_for_direction[head2_direction]):
			player.dash_timer.stop()
			player.on_dash_timer_timeout()
			pipe_entered_velocity_length = player.velocity.length()
			#print(pipe_entered_velocity_length)
			var pipe_travel_speed: float = pipe_entered_velocity_length / 75.0 + 5.0
			
			path.progress_ratio = 1.0
			player.get_node("CollisionShape2D").set_deferred("disabled", true)
			player.gurggu.visible = false
			player.frozen = true
			player.keep_moving = false
			while path.progress_ratio > 0.0:
				path.progress -= pipe_travel_speed
				player.position = path.global_position
				await get_tree().physics_frame
			
			dash_direction = Vector2.ZERO
			change_velocity(head1_direction, pipe_entered_velocity_length, player)
			
			player.get_node("CollisionShape2D").set_deferred("disabled", false)
			player.gurggu.visible = true
			player.frozen = false
			player.keep_moving = true
			can_enter = false
			
			wait_for_release = true
			while Input.get_vector("move_left", "move_right", "move_up", "move_down") == vector_for_direction[head2_direction]:
				await get_tree().physics_frame
			wait_for_release = false
			return
		await get_tree().physics_frame

func change_velocity(exit_direction: Direction, entered_velocity: float, player: Node2D) -> void:
	# Special case for right and left because it wasn't as fast as expected
	if exit_direction == Direction.LEFT or exit_direction == Direction.RIGHT:
		# Add min enterance velocity
		if entered_velocity <= 50:
			entered_velocity = 50
		entered_velocity *= 3.0
		player.coyote_time_wait_for_jump = true
		player.coyote_time_start_time = GameTime.current_time
	
	player.velocity = vector_for_direction[(exit_direction + 2) % 4] * entered_velocity * 2
	#print(entered_velocity)
	#print(player.velocity.length())
func _reset_enterance_duration(_player: Node2D) -> void:
	can_enter = true
