extends CharacterBody2D
class_name Player

static var instance : Player

# Movement & dash related
const speed := 128.0
const water_speed := speed / 2
var player_direction := Vector2.ZERO
const acceleration := 10.0
const friction := 15.0

const dash_speed := 250
var dash_count := 1
var dash_direction := Vector2.ZERO
var dash_multiplier := 1.0
const dash_buffer_time := 0.5
const dash_duration := 0.25
var is_dash_buffered := false

var frame_counter := 0

var gravity := 15
var fast_gravity := gravity * 2
const max_fall_speed := 300

# Jump related
const jump_speed := -250.0
var can_jump := false

var is_jump_buffered := false
const jump_buffer_time := 0.3
var jump_held := false
var jump_hold_time := 0.0
const jump_height_cut := 0.4

@onready var dash_timer := $DashTimer
@onready var coyote_time_duration := $CoyoteTimer
@onready var jump_buffer_duration := $JumpBufferTimer
@onready var jump_timer := $JumpTimer
@onready var gurggu := $Gurggu
@onready var animation_player := $AnimationPlayer
@onready var water_detector := $WaterDetector
@onready var above_water_detector := $AboveWaterDetector
@onready var afterimage_spawner := $AfterimageSpawner
@onready var health : EntityHealth = $EntityHealth

# Blinking
var blinking_texture : Texture2D = preload("res://player/textures/Gurggu_spritesheet_eyes_closed.png")
var default_texture : Texture2D = preload("res://player/textures/Gurggu sprite sheet.png")
var interval_between_blinks: int = randi_range(210, 300)
var blinking_duration := 5

func _ready() -> void:
	instance = self

func _physics_process(delta: float) -> void:
	# Track jump hold time
	if jump_held:
		jump_hold_time += delta

	if !can_jump and (is_on_floor() or is_in_water()):
		can_jump = true
		

	# Handle player jump press
	if Input.is_action_just_pressed("jump"):
		jump_held = true
		jump_hold_time = 0.0

		if can_jump:
			jump()
		else:
			is_jump_buffered = true
			jump_buffer_duration.start(jump_buffer_time)

	# Begin coyote time
	if !is_on_floor() and can_jump and coyote_time_duration.is_stopped():
		coyote_time_duration.start(0.1)

	if is_on_floor():
		coyote_time_duration.stop()
		if dash_timer.is_stopped() and is_on_floor():
			dash_count = 1
		if is_jump_buffered:
			jump()
			is_jump_buffered = false


	# clamped fall speed
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed

	# movement
	player_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if is_dashing():
		if dash_timer.time_left >= (dash_duration - dash_buffer_time) and !is_dash_buffered:
			buffer_dash_inputs()
		velocity = dash_direction * dash_speed * dash_multiplier

	else:
		is_dash_buffered = false
		if !is_on_floor():
			if velocity.y > 0:
				velocity.y += (fast_gravity if Input.is_action_pressed("move_down") else gravity)
			else: 
				velocity.y += gravity

		# check direction for only x axis
		var player_direction_x := Input.get_axis("move_left", "move_right")
		# lerp smoothen movement
		var velocity_weight: float = delta * (acceleration if player_direction_x else friction)

		# check for downleft and downright inputs and reset movement to zero
		if is_on_floor() and player_direction.y > 0 and player_direction_x:
			velocity.x = lerpf(velocity.x, 0.0, velocity_weight)
		else:
			velocity.x = lerpf(velocity.x, player_direction_x * speed, velocity_weight)

		if abs(velocity.x) < 0.1:
			velocity.x = 0

		# Dash
		if Input.is_action_just_pressed("dash") and dash_count > 0:
			dash_count -= 1
			dash_direction = player_direction
			if player_direction == Vector2.ZERO:
				if gurggu.flip_h:
					dash_direction = Vector2.RIGHT
				else:
					dash_direction = Vector2.LEFT
			dash_timer.start(dash_duration)
			afterimage_spawner.make_afterimage()
			afterimage_spawner.start_spawning()

	if is_in_water():
		can_jump = true
		if dash_timer.is_stopped():
			dash_count = 1

		if !is_dashing():
			if Input.is_action_just_pressed("jump"):
				jump()
				jump_timer.start(0.15)
			elif jump_timer.is_stopped():
				velocity = player_direction * water_speed 
		if jump_timer.is_stopped():
			if is_close_to_surface():
				if player_direction.y < 0:
					velocity.y = 0
				velocity.y -= 10
			else:
				velocity.y += gravity / 2.0


	draw_debug_text()
	set_player_flip_h()
	animate_player()
	move_and_slide()

func draw_debug_text() -> void:
	$Label.text = str(player_direction, "\n", $EntityHealth.health)

func jump() -> void:
	velocity.y = jump_speed
	can_jump = false

	# short hop after jump buffer
	if not Input.is_action_pressed("jump"):
		velocity.y *= jump_height_cut

func on_jump_buffer_timeout() -> void:
	is_jump_buffered = false

func on_coyote_timer_timeout() -> void:
	can_jump = false

func on_dash_timer_timeout() -> void:
	velocity = Vector2.ZERO
	afterimage_spawner.stop_spawning()

func _input(event: InputEvent) -> void:
	if event.is_action_released("jump"):
		jump_held = false
		
		# reduce the jump by a certain amount if released jump before the apex
		if velocity.y < 0.0:
			velocity.y *= jump_height_cut

func is_dashing() -> bool:
	return !dash_timer.is_stopped()

func is_jumping() -> bool:
	return !jump_timer.is_stopped()

func buffer_dash_inputs() -> void:
	if player_direction != Vector2.ZERO:
		dash_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	is_dash_buffered = true

func is_in_water() -> bool:
	return water_detector.has_overlapping_bodies()

func is_close_to_surface() -> bool:
	return !above_water_detector.has_overlapping_bodies()

func animate_player() -> void:
	if velocity.x != 0:
		animation_player.play("walk")

	elif !animation_player.is_playing() and animation_player.current_animation == "walk":
		animation_player.play("idle")

	# jump & fall
	if velocity.y > 0:
		animation_player.play("falling")
	if velocity.y < 0:
		animation_player.play("falling_up")
	
	# blink
	if interval_between_blinks != 0:
		interval_between_blinks -= 1
	else:
		gurggu.set_texture(blinking_texture)
		blinking_duration -= 1
		if blinking_duration == 0:
			gurggu.set_texture(default_texture)
			blinking_duration = 5
			interval_between_blinks = randi_range(210, 300)

func set_player_flip_h() -> void:
	if player_direction.x != 0:
		gurggu.flip_h = player_direction.x > 0
