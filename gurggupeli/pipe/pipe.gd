extends Node2D

@export var head1_direction: Direction
@export var head2_direction: Direction
@onready var head_1: Area2D = $Head1
@onready var head_2: Area2D = $Head2
@onready var path: PathFollow2D = $Path2D/PathFollow2D
var wait_for_release: bool = false



enum Direction {
	DOWN = 0,
	UP = 2,
	RIGHT = 3,
	LEFT = 1
}

const axis_for_direction: Dictionary[Direction, Vector2] = {
	Direction.UP: Vector2.UP,
	Direction.DOWN: Vector2(1, -1),
	Direction.LEFT: Vector2(-1, 1),
	Direction.RIGHT: Vector2(-1, 1)
}

const action_for_direction: Dictionary[Direction, StringName] = {
	Direction.UP: "move_down",
	Direction.DOWN: "move_up",
	Direction.LEFT: "move_right",
	Direction.RIGHT: "move_left"
}

func _on_head_2_entered(player: Node2D) -> void:
	var pipe_entered_velocity: float = player.velocity.length() / 50.0 + 1.0
	print(pipe_entered_velocity)
	path.progress_ratio = 0.0
	while head_2.overlaps_body(player):
		if !wait_for_release and Input.is_action_pressed(action_for_direction[head2_direction]):
			path.progress_ratio = 1.0
			player.get_node("CollisionShape2D").set_deferred("disabled", true)
			while path.progress_ratio > 0.0:
				path.progress -= pipe_entered_velocity
				player.position = path.global_position
				await get_tree().physics_frame
			player.get_node("CollisionShape2D").set_deferred("disabled", false)
			change_velocity(head2_direction, head1_direction, player)
			wait_for_release = true
			while Input.is_action_pressed(action_for_direction[head2_direction]):
				await get_tree().physics_frame
			wait_for_release = false
			return
		await get_tree().physics_frame


func _on_head_1_entered(player: Node2D) -> void:
	var pipe_entered_velocity: float = player.velocity.length() / 50.0 + 1.0
	print(pipe_entered_velocity)
	while head_1.overlaps_body(player):
		if !wait_for_release and Input.is_action_pressed(action_for_direction[head1_direction]):
			#get_tree().paused = true
			player.get_node("CollisionShape2D").set_deferred("disabled", true)
			while path.progress_ratio < 1.0:
				path.progress += pipe_entered_velocity
				player.position = path.global_position
				await get_tree().physics_frame
			player.get_node("CollisionShape2D").set_deferred("disabled", false)
			
			change_velocity(head1_direction, head2_direction, player)
			wait_for_release = true
			while Input.is_action_pressed(action_for_direction[head1_direction]):
				await get_tree().physics_frame
			wait_for_release = false
			return
		await get_tree().physics_frame
		
func change_velocity(entrance_direction: Direction, exit_direction:Direction, player:Node2D) -> void:
	if abs(entrance_direction-exit_direction) == 2: #suoraputki
		return
	elif entrance_direction == exit_direction: #180 putki
		player.velocity *= -1
	else:
		player.velocity = player.velocity.rotated(PI/2 if posmod((entrance_direction - exit_direction), 4) == 1 else -PI/2)
