extends Entity
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
var max_dashes := 1
var dash_direction := Vector2.ZERO
const dash_buffer_time := 0.05
const dash_duration := 0.25
var is_dash_buffered := false
var coyote_time_duration := 0.1 

var gravity := 15
var fast_gravity := gravity * 2
var water_gravity := gravity / 2.0
const max_fall_speed := 300

var respawn_pos : Vector2
var next_reset_time : int = GameTime.current_time
var reset_interval := 4
var first_time_on_ground := true

# Jump related
const jump_speed := -250.0
var can_jump := false
var water_jump_time := 0.15
var keep_dash_velocity := false

var is_jump_buffered := false
const jump_buffer_time := 0.3
const jump_height_cut := 0.3

@onready var dash_timer := $DashTimer
@onready var coyote_time_timer := $CoyoteTimer
@onready var jump_buffer_timer := $JumpBufferTimer
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
	respawn_pos = position

func _physics_process(delta: float) -> void:
	# testing
	if is_dashing() and is_on_floor() and (is_jump_buffered or Input.is_action_just_pressed("jump")):
		dash_timer.stop()
		on_dash_timer_timeout()
	
	# Handle jump
	if !can_jump and (is_on_floor() or is_in_water()):
		can_jump = true
	
	if Input.is_action_just_pressed("jump"):
		if can_jump:
			jump()
		else:
			is_jump_buffered = true
			jump_buffer_timer.start(jump_buffer_time)
	
	# Coyote time
	if !is_on_floor() and can_jump and coyote_time_timer.is_stopped():
		coyote_time_timer.start(coyote_time_duration)
	
	if is_on_floor() == false:
		first_time_on_ground = true
	
	# All stuff that happens when on floor
	if is_on_floor():
		coyote_time_timer.stop()
	
		if first_time_on_ground:
			next_reset_time = GameTime.current_time
			first_time_on_ground = false
	
		if next_reset_time + reset_interval == GameTime.current_time:
			keep_dash_velocity = false
			
		if dash_timer.is_stopped():
			dash_count = max_dashes
	
		if is_jump_buffered:
			jump()
			is_jump_buffered = false
		
	# Clamped fall speed
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
	
	# Movement
	if is_dashing():
		# Buffer dash inputs
		if !is_dash_buffered and dash_timer.time_left >= (dash_duration - dash_buffer_time):
			velocity = Vector2.ZERO
			buffer_dash_inputs()
		else:
			velocity = dash_speed * dash_direction
	else:
		is_dash_buffered = false
		
		# Gravity
		if !is_on_floor():
			if velocity.y > 0:
				velocity.y += (fast_gravity if Input.is_action_pressed("move_down") else gravity)
			else: 
				velocity.y += gravity
		
		player_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var velocity_weight: float = delta * (acceleration if player_direction.x else friction)
		# Check for downleft and downright inputs and reset movement to zero with lerp, else move player
		if (is_on_floor() and player_direction.y > 0) and player_direction.x and !is_dashing():
			velocity.x = lerpf(velocity.x, 0.0, velocity_weight)
		else:
			if keep_dash_velocity:
				velocity_weight = 0.9
				velocity.x = lerpf(velocity.x, player_direction.x * speed * 1.5, velocity_weight)
				if abs(velocity.x) < speed / 2:
					keep_dash_velocity = false 
			else:
				velocity.x = lerpf(velocity.x, player_direction.x * speed, velocity_weight)
	
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
		keep_dash_velocity = false
		can_jump = true
		if dash_timer.is_stopped():
			dash_count = max_dashes
	
		if !is_dashing():
			if Input.is_action_just_pressed("jump"):
				jump()
				jump_timer.start(water_jump_time)
			elif jump_timer.is_stopped():
				velocity = player_direction * water_speed 
		if jump_timer.is_stopped():
			if is_close_to_surface():
				if player_direction.y < 0:
					velocity.y = 0
				velocity.y -= 10
			else:
				velocity.y += water_gravity
	
	# Debug stuff
	if Input.is_action_just_pressed("ui_focus_next"):
		health.health += 3
	health.health = clamp(health.health, 0, 15)
	
	draw_debug_text()
	set_player_flip_h()
	animate_player()
	move_and_slide()

func draw_debug_text() -> void:
	$Label.text = str(velocity.x, "\n", health.health, "\n", keep_dash_velocity)

func jump() -> void:
	velocity.y = jump_speed
	can_jump = false

	# If only pressed jump for a few frames in a buffer perform a small jump
	if !Input.is_action_pressed("jump"):
		velocity.y *= jump_height_cut

func on_jump_buffer_timeout() -> void:
	is_jump_buffered = false

func on_coyote_timer_timeout() -> void:
	can_jump = false

func on_dash_timer_timeout() -> void:
	if (is_jump_buffered or Input.is_action_just_pressed("jump")) and velocity.x != 0 and dash_direction.y >= 0:
		keep_dash_velocity = true
	else:
		velocity = velocity.lerp(Vector2.ZERO, 0.5)
	afterimage_spawner.stop_spawning()

func _input(event: InputEvent) -> void:
	if event.is_action_released("jump"):
		# Cut the jump height
		if velocity.y < 0.0:
			velocity.y *= jump_height_cut

func is_dashing() -> bool:
	return !dash_timer.is_stopped()

func is_jumping() -> bool:
	return !jump_timer.is_stopped()

func buffer_dash_inputs() -> void:
	var buffered_dash_direction : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if buffered_dash_direction == Vector2.ZERO:
		return
	if buffered_dash_direction != dash_direction:
		is_dash_buffered = true
	dash_direction = buffered_dash_direction



func is_in_water() -> bool:
	return water_detector.has_overlapping_bodies()

func is_close_to_surface() -> bool:
	return !above_water_detector.has_overlapping_bodies()

func _die() -> void:
	GUI.show_death_screen()

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
