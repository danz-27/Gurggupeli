extends CharacterBody2D

#movement & dash related
var speed := 128.0
var player_direction := Vector2.ZERO
var acceleration := 10.0
var friction := 15.0

var dash_speed := 250
var dash_count := 1
var dash_direction := Vector2.ZERO
var dash_multiplier := 1.0

var grounded_frames_amount := 0

var gravity := 15
var max_fall_speed := 300

#jump related
var jump_speed := -250.0
var can_jump := false

var jump_buffer := false
var jump_buffer_time := 0.2
var jump_held := false
var jump_hold_time := 0.0
var jump_height_cut := 0.4

#timers
@onready var dash_duration := $DashTimer
@onready var coyote_time_duration := $CoyoteTimer
@onready var jump_buffer_duration := $JumpBufferTimer


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	# Track jump hold time
	if jump_held:
		jump_hold_time += delta

	# Handle player jump press
	if Input.is_action_just_pressed("jump"):
		jump_held = true
		jump_hold_time = 0.0

		if can_jump:
			jump()
		else:
			jump_buffer = true
			jump_buffer_duration.start(jump_buffer_time)

	if can_jump == false and is_on_floor():
		can_jump = true

	# Begin coyote time
	if not is_on_floor() and can_jump and coyote_time_duration.is_stopped():
		coyote_time_duration.start(0.1)

	if is_on_floor():
		coyote_time_duration.stop()
		if dash_duration.is_stopped() and is_on_floor():
			dash_count = 1
		if jump_buffer:
			jump()
			jump_buffer = false


		grounded_frames_amount += 1
		grounded_frames_amount %= 10
		if grounded_frames_amount == 9:
			dash_multiplier = 1.0
			
	else:
		grounded_frames_amount = 0


	# clamped fall speed
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed

	# movement
	player_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if is_dashing():
		velocity = dash_direction * dash_speed * dash_multiplier
	else:
		if not is_on_floor():
			velocity.y += gravity
		# check direction for only x axis
		var player_direction_x := Input.get_axis("move_left", "move_right")

		# lerp smoothen movement
		var velocity_weight: float = delta * (acceleration if player_direction_x else friction)

		# check for downleft and downright inputs and reset movement to zero
		if is_on_floor() and player_direction.y > 0 and player_direction_x:
			velocity.x = lerp(velocity.x, 0.0, velocity_weight)
			if abs(velocity.x) < 0.1:
				velocity.x = 0

		else:
			velocity.x = lerp(velocity.x, player_direction_x * speed, velocity_weight)
			if abs(velocity.x) < 0.1:
				velocity.x = 0

		# Dash
		if Input.is_action_just_pressed("dash") and dash_count > 0:
			dash_count -= 1
			dash_direction = player_direction
			dash_duration.start(0.25)
			velocity = dash_direction * dash_speed * dash_multiplier

	draw_debug_text()
	set_player_flip_h()
	animate_player()
	move_and_slide()


func draw_debug_text() -> void:
	$Label.text = str(grounded_frames_amount, "\n", velocity.x)


func jump() -> void:
	
	velocity.y = jump_speed
	can_jump = false

	# short hop after jump buffer
	if not Input.is_action_pressed("jump"):
		velocity.y *= jump_height_cut
	if is_dashing():
		if player_direction == Vector2.DOWN or player_direction == Vector2.UP:
			dash_duration.stop()
		else:
			dash_multiplier *= 1.2
			dash_duration.stop()
	

func on_jump_buffer_timeout() -> void:
	jump_buffer = false


func on_coyote_timer_timeout() -> void:
	can_jump = false


func _input(event):
	if event.is_action_released("jump"):
		jump_held = false
		
		# reduce the jump by a certain amount if released jump before the apex
		if velocity.y < 0.0:
			velocity.y *= jump_height_cut


func is_dashing() -> bool:
	return not dash_duration.is_stopped()


func on_dash_timer_timeout() -> void:
	velocity = Vector2.ZERO


func animate_player() -> void:
	if velocity.x != 0:
		$AnimationPlayer.play("walk")

	elif not($AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "walk"):
		$AnimationPlayer.play("idle")

	#jump & fall
	if velocity.y > 0:
		$AnimationPlayer.play("falling")
	if velocity.y < 0:
		$AnimationPlayer.play("falling_up")

func set_player_flip_h() -> void:
	if player_direction.x != 0:
		$Gurggu.flip_h = player_direction.x > 0
