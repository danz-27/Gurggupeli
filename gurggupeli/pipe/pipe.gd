extends Node2D

@export var head1_direction: Direction
@export var head2_direction: Direction
@onready var head_1: Area2D = $Head1
@onready var head_2: Area2D = $Head2
@onready var path: PathFollow2D = $Path2D/PathFollow2D
var wait_for_release: bool = false
var dash_direction: Vector2


enum Direction {
	DOWN = 0,
	UP = 2,
	RIGHT = 3,
	LEFT = 1
}

const axis_for_direction: Dictionary[Direction, Vector2] = {
	Direction.UP: Vector2.UP,
	Direction.DOWN: Vector2.DOWN,
	Direction.LEFT: Vector2.LEFT,
	Direction.RIGHT: Vector2.RIGHT
}

const action_for_direction: Dictionary[Direction, StringName] = {
	Direction.UP: "move_down",
	Direction.DOWN: "move_up",
	Direction.LEFT: "move_right",
	Direction.RIGHT: "move_left"
}

func _on_head_1_entered(player: Node2D) -> void:
	while head_1.overlaps_body(player):
		if player.is_dashing():
			dash_direction = player.dash_direction
		else:
			dash_direction = Vector2.ZERO
		if !wait_for_release and (Input.is_action_pressed(action_for_direction[head1_direction]) or (dash_direction == axis_for_direction[(head1_direction + 2) % 4])):
			var pipe_entered_velocity_length: float = player.velocity.length()
			var pipe_travel_speed: float = pipe_entered_velocity_length / 75.0 + 5.0
			
			player.get_node("CollisionShape2D").set_deferred("disabled", true)
			player.gurggu.visible = false
			player.frozen = true
			while path.progress_ratio < 1.0:
				path.progress += pipe_travel_speed
				player.position = path.global_position
				await get_tree().physics_frame
			
			dash_direction = Vector2.ZERO
			change_velocity(head2_direction, pipe_entered_velocity_length, player)
			
			player.get_node("CollisionShape2D").set_deferred("disabled", false)
			player.gurggu.visible = true
			player.frozen = false
			
			wait_for_release = true
			while Input.is_action_pressed(action_for_direction[head1_direction]):
				await get_tree().physics_frame
			wait_for_release = false
			return
		await get_tree().physics_frame

func _on_head_2_entered(player: Node2D) -> void:
	path.progress_ratio = 0.0
	while head_2.overlaps_body(player):
		if player.is_dashing():
			dash_direction = player.dash_direction
		else:
			dash_direction = Vector2.ZERO
		if !wait_for_release and (Input.is_action_pressed(action_for_direction[head2_direction]) or (dash_direction == axis_for_direction[(head2_direction + 2) % 4])):
			var pipe_entered_velocity_length: float = player.velocity.length()
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
			
			wait_for_release = true
			while Input.is_action_pressed(action_for_direction[head2_direction]):
				await get_tree().physics_frame
			wait_for_release = false
			return
		await get_tree().physics_frame

func change_velocity(exit_direction: Direction, velocity: float, player:Node2D) -> void:
	# Special case for right and left because it wasn't as fast as expected
	if exit_direction == Direction.LEFT or exit_direction == Direction.RIGHT:
		velocity *= 3.0
	player.velocity = axis_for_direction[exit_direction] * velocity
