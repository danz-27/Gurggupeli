extends Node2D

var pieces_in_x_direction: int = 5
var pieces_in_y_direction: int = 5
var shapes: Array = ["straight", "left_turn", "right_turn"]
var pipes: Array = []
var won: bool = false

@onready var path: Path2D = $pipe/Path2D
@onready var texture: Sprite2D = $"hieno onnittelu"
@onready var head1: Area2D = $pipe/Head1
@onready var head2: Area2D = $pipe/Head2

var move_position_to_direction: Dictionary = {
	0 : [0, -1],
	1 : [1, 0],
	2 : [0, 1],
	3 : [-1, 0]
}

func check_for_win(starting_position: Array, ending_position: Array) -> bool:
	path.curve.clear_points()
	var direction_coming_from: int = 1
	var position_trying_to_go_to_x: int = starting_position[0]
	var position_trying_to_go_to_y: int = starting_position[1]
	path.curve.add_point(Vector2(head1.position))
	path.curve.add_point(Vector2(position_trying_to_go_to_x*24, position_trying_to_go_to_y*24))
	var pipe_trying_to_go_to: Node = pipes[position_trying_to_go_to_x * 5 + position_trying_to_go_to_y]
	var iterations: int = 0
	var maximum_steps: int = pieces_in_x_direction * pieces_in_y_direction
	for _steps in maximum_steps:
		iterations = 1
		for directions: int in pipe_trying_to_go_to.class_pipe_instance.get_pipe_hole_directions():
			if direction_coming_from == (directions + 2) % 4:
				#print("pipe before moving: ", position_trying_to_go_to_x * 5 + position_trying_to_go_to_y)
				#print("directions: ", pipe_trying_to_go_to.class_pipe_instance.get_pipe_hole_directions())
				#print("trying to move to direction: ", pipe_trying_to_go_to.class_pipe_instance.get_pipe_hole_directions()[iterations])
				#print("trying to move to position x: ", move_position_to_direction[pipe_trying_to_go_to.class_pipe_instance.get_pipe_hole_directions()[iterations]][0])
				#print("trying to move to position y: ", move_position_to_direction[pipe_trying_to_go_to.class_pipe_instance.get_pipe_hole_directions()[iterations]][1])
				#print("position before trying to move: ",position_trying_to_go_to_x, position_trying_to_go_to_y)
				direction_coming_from = pipe_trying_to_go_to.class_pipe_instance.get_pipe_hole_directions()[iterations]
				#print("direction coming from: ", direction_coming_from)
				position_trying_to_go_to_x += move_position_to_direction[pipe_trying_to_go_to.class_pipe_instance.get_pipe_hole_directions()[iterations]][0]
				position_trying_to_go_to_y += move_position_to_direction[pipe_trying_to_go_to.class_pipe_instance.get_pipe_hole_directions()[iterations]][1]
				path.curve.add_point(Vector2(position_trying_to_go_to_x*24, position_trying_to_go_to_y*24))
				#print("position after trying to move: ", position_trying_to_go_to_x, position_trying_to_go_to_y)
				#print("Current pipe trying to get to: ", position_trying_to_go_to_x * 5 + position_trying_to_go_to_y)
				if position_trying_to_go_to_x <= pieces_in_x_direction - 1 and position_trying_to_go_to_x >= 0 and position_trying_to_go_to_y >= 0 and position_trying_to_go_to_y <= pieces_in_y_direction - 1:
					pipe_trying_to_go_to = pipes[position_trying_to_go_to_x * 5 + position_trying_to_go_to_y]
				if position_trying_to_go_to_x == ending_position[0] and position_trying_to_go_to_y == ending_position[1]:
					path.curve.add_point(Vector2(head2.position))
					print("connected!")
					return true
				break
			iterations = 0
	print(position_trying_to_go_to_x, position_trying_to_go_to_y)
	if position_trying_to_go_to_x == ending_position[0] and position_trying_to_go_to_y == ending_position[1]:
		print("connected!")
		return true
	else:
		return false

func _ready() -> void:
	for i in range(0, pieces_in_x_direction):
		for j in range(0, pieces_in_y_direction):
			var pipe_piece: Node = preload("res://pipe_minigame_pipe.tscn").instantiate()
			add_child.call_deferred(pipe_piece)
			pipe_piece.global_position = position
			pipe_piece.position.x = i * 24
			pipe_piece.position.y = j * 24
			pipes.append(pipe_piece)

func _physics_process(_delta: float) -> void:
	if won:
		texture.visible = true
		head1.monitoring = true
		head2.monitoring = true
	else:
		texture.visible = false
		head1.monitoring = false
		head2.monitoring = false
