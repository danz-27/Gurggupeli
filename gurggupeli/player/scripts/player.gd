extends CharacterBody2D

var move_speed := 128
var jump_speed := -400.0
var can_jump := false
var dash_speed := 300
var gravity := 15
var dash_count := 1
var dash_direction := Vector2.ZERO
var jump_buffer := false
var jump_buffer_time := 0.5
var max_fall_speed := 300

# Track jump hold
var jump_held := false
var jump_hold_time := 0.0

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
		dash_count = 1
		coyote_time_duration.stop()
		if jump_buffer:
			jump()
			jump_buffer = false

	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed

	# Movement
	var player_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	if is_dashing():
		velocity = dash_direction * dash_speed
	else:
		if not is_on_floor():
			velocity.y += gravity

		velocity.x *= 0.75
		if abs(velocity.x) < 0.1:
			velocity.x = 0

		if player_direction.x != 0:
			velocity.x = player_direction.x * move_speed

		# Dash
		if Input.is_action_just_pressed("dash") and dash_count > 0 and player_direction != Vector2.ZERO:
			dash_count -= 1
			dash_direction = player_direction
			dash_duration.start(0.3)
			velocity = dash_direction * dash_speed

	draw_debug_text()
	set_player_flip_h()
	animate_player()
	move_and_slide()


func draw_debug_text() -> void:
	$Label.text = str(jump_buffer, "\n", velocity.y)
	print(velocity.y)

func jump() -> void:
	velocity.y = jump_speed
	can_jump = false

	# If jump button was already released before jump started → short hop immediately
	if not Input.is_action_pressed("jump"):
		velocity.y *= 0.4


func on_jump_buffer_timeout() -> void:
	jump_buffer = false


func on_coyote_timer_timeout() -> void:
	can_jump = false


func _input(event):
	# Detect release at any time
	if event.is_action_released("jump"):
		jump_held = false
		# If in the air and still moving upward → apply short hop cut
		if velocity.y < 0.0:
			velocity.y *= 0.2


func is_dashing() -> bool:
	return not dash_duration.is_stopped()


func on_dash_timer_timeout() -> void:
	velocity = Vector2.ZERO


func animate_player() -> void:
	
	if velocity.x != 0:
		$AnimationPlayer.play("walk")

	elif not ($AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "walk"):
		$AnimationPlayer.play("idle")
	
	#jump & fall
	if velocity.y > 0:
		$AnimationPlayer.play("falling")
	if velocity.y < 0:
		$AnimationPlayer.play("falling_up")

func set_player_flip_h() -> void:
	if velocity.x != 0:
		$Gurggu.flip_h = velocity.x > 0
