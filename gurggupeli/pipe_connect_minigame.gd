extends Node2D

var pipe_size: int = 24
var pieces_in_x_direction: int = 10
var pieces_in_y_direction: int = 5
var pipes: Array = []
var won: bool = false
var locked: bool = false

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

class agent:
	var positionX: int
	var positionY: int
	var direction_going_to: int
	var max_lifetime: int
	var positions_path: Array
	var positions_path_in_pipe_numbers: Array
	
	var move_position_to_direction: Dictionary = {
	0 : [0, -1],
	1 : [1, 0],
	2 : [0, 1],
	3 : [-1, 0]}
	
	func move() -> void:
		positionX += move_position_to_direction[direction_going_to][0]
		positionY += move_position_to_direction[direction_going_to][1]
		max_lifetime -= 1
	
func calculate_if_possible(starting_position: Array[int], ending_position: Array[int], direction_coming_from: int) -> bool:
	var agents: Array[agent]
	var winning_positions_path: Array
	var times_run: int = 0
	var maximum_times_to_run: int = 200
	agents.append(agent.new())
	agents[0].direction_going_to = direction_coming_from
	agents[0].positionX = starting_position[0]
	agents[0].positionY = starting_position[1]
	agents[0].max_lifetime = pieces_in_x_direction * pieces_in_y_direction
	#print("starting position: ", agents[0].positionX * pieces_in_y_direction + agents[0].positionY)
	var reached_end: bool = false
	while !reached_end and agents.size() > 0 and times_run < maximum_times_to_run:
		for A in agents:
			#print("Going to direction ", A.direction_going_to, " From position ", A.positionX * pieces_in_y_direction + A.positionY)
			A.move()
			#print("moved to: ", A.positionX * pieces_in_y_direction + A.positionY)
			if A.positionX == ending_position[0] and A.positionY == ending_position[1]:
				reached_end = true
				winning_positions_path = A.positions_path_in_pipe_numbers
			if A.positionX > pieces_in_x_direction - 1 or A.positionX < 0 or A.positionY > pieces_in_y_direction - 1 or A.positionY < 0:
				agents.erase(A)
				A = null
				#print("went out of bounds")
				break
			if [A.positionX, A.positionY] not in A.positions_path:
				A.positions_path.append([A.positionX, A.positionY])
				A.positions_path_in_pipe_numbers.append(A.positionX * pieces_in_y_direction + A.positionY)
			elif pipes[A.positionX * pieces_in_y_direction + A.positionY].shape != "4-way_cross":
				#print("Was already in this tile")
				agents.erase(A)
				A = null
				break
			if A.max_lifetime <= 0:
				agents.erase(A)
				A = null
				break
			pipes[A.positionX * pieces_in_y_direction + A.positionY].has_agent = true
			if pipes[A.positionX * pieces_in_y_direction + A.positionY].shape == "turn":
				#print(A.positionX * pieces_in_y_direction + A.positionY, " is a turn")
				var new_agent1: agent = agent.new()
				var new_agent2: agent = agent.new()
				new_agent1.direction_going_to = (A.direction_going_to + 1) % 4
				new_agent1.positionX = A.positionX
				new_agent1.positionY = A.positionY
				new_agent1.max_lifetime = A.max_lifetime
				new_agent1.positions_path = A.positions_path.duplicate(true)
				new_agent1.positions_path_in_pipe_numbers = A.positions_path_in_pipe_numbers.duplicate(true)
				new_agent2.direction_going_to = (A.direction_going_to + 3) % 4
				new_agent2.positionX = A.positionX
				new_agent2.positionY = A.positionY
				new_agent2.max_lifetime = A.max_lifetime
				new_agent2.positions_path = A.positions_path.duplicate(true)
				new_agent2.positions_path_in_pipe_numbers = A.positions_path_in_pipe_numbers.duplicate(true)
				agents.append(new_agent1)
				agents.append(new_agent2)
				agents.erase(A)
				A = null
				break
			await get_tree().physics_frame
			times_run += 1
	if reached_end:
		for pipe_instance: pipe in pipes:
			pipe_instance.has_agent = false
			if pipe_instance.position_in_array in winning_positions_path:
				pipe_instance.has_agent = true
		#print(winning_positions_path)
		return true
	#print(times_run)
	return false

func check_for_win(starting_position: Array, ending_position: Array, direction_coming_from: int) -> bool:
	var maximum_steps: int = pieces_in_x_direction * pieces_in_y_direction
	path.curve.clear_points()
	var position_trying_to_go_to_x: int = starting_position[0] + move_position_to_direction[direction_coming_from][0]
	var position_trying_to_go_to_y: int = starting_position[1] + move_position_to_direction[direction_coming_from][1]
	path.curve.add_point(Vector2(head1.position))
	path.curve.add_point(Vector2(position_trying_to_go_to_x*pipe_size, position_trying_to_go_to_y*pipe_size))
	var pipe_trying_to_go_to: Node = pipes[position_trying_to_go_to_x * pieces_in_y_direction + position_trying_to_go_to_y]
	var iterations: int = 0
	for _steps in maximum_steps:
		iterations = 5
		for directions: int in pipe_trying_to_go_to.get_pipe_hole_directions():
			if direction_coming_from == (directions + 2) % 4:
				#print("pipe before moving: ", position_trying_to_go_to_x * 5 + position_trying_to_go_to_y)
				#print("directions: ", pipe_trying_to_go_to.get_pipe_hole_directions())
				#print("trying to move to direction: ", pipe_trying_to_go_to.get_pipe_hole_directions()[iterations % 4])
				#print("trying to move to position x: ", move_position_to_direction[pipe_trying_to_go_to.get_pipe_hole_directions()[iterations % 4]][0])
				#print("trying to move to position y: ", move_position_to_direction[pipe_trying_to_go_to.get_pipe_hole_directions()[iterations % 4]][1])
				#print("position before trying to move: ",position_trying_to_go_to_x, position_trying_to_go_to_y)
				direction_coming_from = pipe_trying_to_go_to.get_pipe_hole_directions()[iterations % 4]
				#print("direction coming from: ", direction_coming_from)
				position_trying_to_go_to_x += move_position_to_direction[pipe_trying_to_go_to.get_pipe_hole_directions()[iterations % 4]][0]
				position_trying_to_go_to_y += move_position_to_direction[pipe_trying_to_go_to.get_pipe_hole_directions()[iterations % 4]][1]
				path.curve.add_point(Vector2(position_trying_to_go_to_x*pipe_size, position_trying_to_go_to_y*pipe_size))
				#print("position after trying to move: ", position_trying_to_go_to_x, position_trying_to_go_to_y)
				#print("Current pipe trying to get to: ", position_trying_to_go_to_x * 5 + position_trying_to_go_to_y)
				if position_trying_to_go_to_x <= pieces_in_x_direction - 1 and position_trying_to_go_to_x >= 0 and position_trying_to_go_to_y >= 0 and position_trying_to_go_to_y <= pieces_in_y_direction - 1:
					pipe_trying_to_go_to = pipes[position_trying_to_go_to_x * pieces_in_y_direction + position_trying_to_go_to_y]
				if position_trying_to_go_to_x == ending_position[0] and position_trying_to_go_to_y == ending_position[1]:
					path.curve.add_point(Vector2(head2.position))
					#print("connected!")
					return true
				break
			iterations -= 1
			
	#print(position_trying_to_go_to_x, position_trying_to_go_to_y)
	if position_trying_to_go_to_x == ending_position[0] and position_trying_to_go_to_y == ending_position[1]:
		#print("connected!")
		return true
	else:
		return false

func create_tiles() -> void:
	for i in range(0, pieces_in_x_direction):
		for j in range(0, pieces_in_y_direction):
			var pipe_piece: pipe = preload("res://pipe_minigame_pipe.tscn").instantiate()
			add_child(pipe_piece)
			pipe_piece.global_position = position
			pipe_piece.position.x = i * pipe_size
			pipe_piece.position.y = j * pipe_size
			pipes.append(pipe_piece)
			pipe_piece.update_position_in_array()
	if !await calculate_if_possible([-1, 2], [10, 2], 1):
		#print("busted")
		for pipe_instance: pipe in pipes:
			pipe_instance.queue_free()
		pipes.clear()
		create_tiles()
		
func _activate() -> void:
	create_tiles()

func _ready() -> void:
	create_tiles()

func _physics_process(_delta: float) -> void:
	if won:
		locked = true
		texture.visible = true
		head1.monitoring = true
		head2.monitoring = true
	else:
		texture.visible = false
		head1.monitoring = false
		head2.monitoring = false
