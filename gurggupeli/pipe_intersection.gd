extends Node2D
#
#@export var right_entrance_direction: Direction
#@export var up_entrance_direction: Direction
#@export var left_entrance_direction: Direction
#@export var down_entrance_direction: Direction
#
#@onready var intersection: Area2D = $Intersection
#@onready var right_area: Area2D = $RightEntrance
#@onready var up_area: Area2D = $UpEntrance
#@onready var left_area: Area2D = $LeftEntrance
#@onready var down_area: Area2D = $DownEntrance
#
#@onready var right_entrance: CollisionShape2D = $RightEntrance/CollisionShape2D
#@onready var up_entrance: CollisionShape2D = $UpEntrance/CollisionShape2D
#@onready var left_entrance: CollisionShape2D = $LeftEntrance/CollisionShape2D
#@onready var down_entrance: CollisionShape2D = $DownEntrance/CollisionShape2D
#
#@onready var right_entrance_path: PathFollow2D = $RightEntrance/Path2D/PathFollow2D
#@onready var up_entrance_path: PathFollow2D = $UpEntrance/Path2D/PathFollow2D
#@onready var left_entrance_path: PathFollow2D = $LeftEntrance/Path2D/PathFollow2D
#@onready var down_entrance_path: PathFollow2D = $DownEntrance/Path2D/PathFollow2D
#
#var default_exit_dir: Direction = Direction.NONE
#var default_exit_area: Area2D
#var default_path: PathFollow2D
#
#enum Direction {
	#NONE = -1,
	#RIGHT = 0,
	#UP = 1,
	#LEFT = 2,
	#DOWN = 3
#}
#
#var vector_to_dir: Dictionary[Vector2i, Direction] = {
	#Vector2i.RIGHT: Direction.RIGHT,
	#Vector2i.UP: Direction.UP,
	#Vector2i.LEFT: Direction.LEFT,
	#Vector2i.DOWN: Direction.DOWN
#}
#
#var path_to_area: Dictionary[PathFollow2D, Area2D] = { }
#var area_to_dir: Dictionary[Area2D, Direction] = { }
#
## Convert to string for handling the directions between scenes
#var dir_to_string: Dictionary[Direction, String] = {
	 #Direction.RIGHT: "RIGHT",
	#Direction.UP: "UP", 
	#Direction.LEFT: "LEFT",
	#Direction.DOWN: "DOWN"
#}
#
## change the area2D to path2d once implemented
#var exit_path: Dictionary[Direction, PathFollow2D] = { }
#
#func _ready() -> void:
	#path_to_area[right_entrance_path] = right_area
	#path_to_area[up_entrance_path] = up_area
	#path_to_area[left_entrance_path] = left_area
	#path_to_area[down_entrance_path] = down_area
	#
	#area_to_dir[right_area] = Direction.RIGHT
	#area_to_dir[up_area] = Direction.UP
	#area_to_dir[left_area] = Direction.LEFT
	#area_to_dir[down_area] = Direction.DOWN
	#
	#exit_path[Direction.RIGHT] = right_entrance_path
	#exit_path[Direction.UP] = up_entrance_path
	#exit_path[Direction.LEFT] = left_entrance_path
	#exit_path[Direction.DOWN] = down_entrance_path
#
#func _physics_process(delta: float) -> void:
	##print(defau)
	#pass
#
#func _on_intersection_entered(player: Node2D) -> void:
	#if default_exit_dir == Direction.NONE:
		#return
	#
	#var input_vector: Vector2i = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	## Check if nothing was pressed when entering, to just go to the default exit
	#if input_vector == Vector2i.ZERO:
		#move_from_intersection(player, path_to_area[default_path], default_path)
		#return
	#
	## Turn the input_vector into a Direction
	#var input_direction: Direction = vector_to_dir[input_vector]
	#
	#
	## CALL THE FUNCTION WITH THE LINE PARAMETER
	## Check forward
	#var selected_path: PathFollow2D
	#if input_direction == default_exit_dir:
		#selected_path = check_if_direction_exists_default(default_exit_dir)
	## Check right
	#elif input_direction == (default_exit_dir + 1) % 4:
		#selected_path = check_if_direction_exists_right((default_exit_dir + 1) % 4)
	## Check left
	#else:
		#selected_path = check_if_direction_exists_left((default_exit_dir + 3) % 4)
	#
	#move_from_intersection(player, path_to_area[selected_path], selected_path)
##
##func _on_right_entrance_body_entered(player: Node2D) -> void:
	##print("whar")
	##default_exit_dir = Direction.LEFT
	##default_exit_area = left_area
	##default_path = left_entrance_path
	##Pipe.instance._on_head_1_entered(
		##player,
		##right_area,
		##intersection,
		##Pipe.Direction[dir_to_string[(right_entrance_direction + 2) % 4]], 
		##Pipe.Direction[dir_to_string[default_exit_dir]], 
		##right_entrance_path
	##)
#
#func _on_up_entrance_body_entered(player: Node2D) -> void:
	#default_exit_dir = Direction.DOWN
	#default_exit_area = down_area
	#default_path = down_entrance_path
	#Pipe.instance._on_head_1_entered(
		#player,
		#up_area,
		#intersection,
		#Pipe.Direction[dir_to_string[(up_entrance_direction + 2) % 4]], 
		#Pipe.Direction[dir_to_string[default_exit_dir]], 
		#up_entrance_path
	#)
#
#func _on_left_entrance_body_entered(player: Node2D) -> void:
	#default_exit_dir = Direction.RIGHT
	#default_exit_area = right_area
	#default_path = right_entrance_path
	#Pipe.instance._on_head_1_entered(
		#player,
		#left_area,
		#intersection,
		#Pipe.Direction[dir_to_string[(left_entrance_direction + 2) % 4]], 
		#Pipe.Direction[dir_to_string[default_exit_dir]], 
		#left_entrance_path
	#)
#
#func _on_down_entrance_body_entered(player: Node2D) -> void:
	##print(Pipe.instance)
	#default_exit_dir = Direction.UP
	#default_exit_area = up_area
	#default_path = up_entrance_path
	#Pipe.instance._on_head_1_entered(
		#player,
		#down_area,
		#intersection,
		#Pipe.Direction[dir_to_string[(down_entrance_direction + 2) % 4]], 
		#Pipe.Direction[dir_to_string[default_exit_dir]], 
		#down_entrance_path
	#)
#
#func check_if_direction_exists_default(exit_dir: Direction) -> PathFollow2D:
	#if exit_dir != Direction.NONE:
		#return exit_path[exit_dir]
	#
	## Check if intersection enterance direction +90 deg exists
	#elif (exit_dir + 1) % 4 != Direction.NONE:
		#return exit_path[(exit_dir + 1) % 4]
	## Check if intersection enterance direction +270 deg exists
	#elif (exit_dir + 3) % 4 != Direction.NONE:
		#return exit_path[(exit_dir + 3) % 4]
	## Return the path that the player came from if nothing else worked
	#else:
		#return exit_path[(exit_dir + 2) % 4]
		#
#
#func check_if_direction_exists_right(exit_dir: Direction) -> PathFollow2D:
	#if exit_dir != Direction.NONE:
		#return exit_path[exit_dir]
	#
	## Check if intersection enterance direction +90 deg exists
	#elif (exit_dir + 1) % 4 != Direction.NONE:
		#return exit_path[(exit_dir + 1) % 4]
	## Check if intersection enterance direction +180 deg exists
	#elif (exit_dir + 2) % 4 != Direction.NONE:
		#return exit_path[(exit_dir + 2) % 4]
	## Return the path that the player came from if nothing else worked
	#else:
		#return exit_path[(exit_dir + 3) % 4]
#
#func check_if_direction_exists_left(exit_dir: Direction) -> PathFollow2D:
	#if exit_dir != Direction.NONE:
		#return exit_path[exit_dir]
	#
	## Check if intersection enterance direction +270 deg exists
	#elif (exit_dir + 3) % 4 != Direction.NONE:
		#return exit_path[(exit_dir + 3) % 4]
	## Check if intersection enterance direction +180 deg exists
	#elif (exit_dir + 2) % 4 != Direction.NONE:
		#return exit_path[(exit_dir + 2) % 4]
	## Return the path that the player came from if nothing else worked
	#else:
		#return exit_path[(exit_dir + 1) % 4]
#
#
#func move_from_intersection(player: Node2D, head_1_area: Area2D, path: PathFollow2D) -> void:
	#var pipe_entered_velocity_length: float = Pipe.instance.pipe_entered_velocity_length
	#var pipe_travel_speed: float = pipe_entered_velocity_length / 75.0 + 5.0
	#var head_1_direction: Pipe.Direction = Pipe.Direction[dir_to_string[area_to_dir[head_1_area]]]
	#path.progress_ratio = 1.0
	#while path.progress_ratio > 0.0:
		#path.progress -= pipe_travel_speed
		#player.position = path.global_position
		#await get_tree().physics_frame
	#
	#Pipe.instance.dash_direction = Vector2.ZERO
	#Pipe.instance.change_velocity(head_1_direction, pipe_entered_velocity_length, player)
	#
	#player.get_node("CollisionShape2D").set_deferred("disabled", false)
	#player.gurggu.visible = true
	#player.frozen = false
	#Pipe.instance.can_enter = false
	#
	##Pipe.instance.wait_for_release = true
	##while Input.is_action_pressed(Pipe.action_for_direction[head_1_direction]):
		##await get_tree().physics_frame
	##Pipe.instance.wait_for_release = false
##
##func _reset_intersection_enterance_duration(player: Node2D) -> void:
	##Pipe.instance._reset_enterance_duration(player)
