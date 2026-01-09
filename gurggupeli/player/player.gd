extends Entity
class_name Player

static var instance : Player

# Movement & dash related
const SPEED: float = 128.0
const WATER_SPEED: float = SPEED / 2
var player_direction := Vector2.ZERO
const acceleration := 10.0
const friction := 15.0

const DEFAULT_DASH_SPEED: float = 250.0
var dash_speed := 250.0
var dash_count := 1
var max_dashes := 1
var dash_multiplier: float = 1.2
var dash_direction := Vector2.ZERO
const dash_buffer_time := 0.05
const dash_duration := 0.25
var is_dash_buffered := false
var coyote_time_duration := 4
var coyote_time_start_time: int
var coyote_time_wait_for_jump: bool = false
var velocity_lerp_reset_threshold: = 0.1
var reset_velocity: bool = false

var gravity := 15
var fast_gravity := gravity * 2
var water_gravity := 5
const max_fall_speed := 250

var respawn_pos : Vector2
var next_reset_time : int = GameTime.current_time
var reset_interval: int = 4
var first_time_on_ground: bool = true
var first_time_in_air: bool = !first_time_on_ground
var last_movement_direction: int = -1
var has_player_direction_changed: bool = false
var first_time_changing_direction: bool = false
var is_crouching: bool = false
var last_pressed_input: float = -1.0

# Jump related
const jump_speed: float = -250.0
var last_dashed: int
var water_jump_time: float = 0.15
var keep_dash_velocity := false
var keep_dash_speed_weight: float = 0.01
var keep_dash_speed: float = dash_speed
var keep_dash_speed_threshold: float = SPEED / 4.0
var reverse_hyper_dash_leeway_time: bool = false
var last_activated_keep_dash_speed: int
var keep_dash_speed_reset_interval: int = 100

var is_jump_buffered: bool = false
const jump_buffer_duration: float = 0.2
const jump_height_cut: float = 0.4
var first_time_leaving_water: bool = false
var first_time_activating: bool = true
var last_left_water: int
const WATER_JUMP_BUFFER_DURATION: int = 5

# ----------------------
var blinking_texture : Texture2D = preload("res://player/textures/Gurggu_spritesheet_eyes_closed.png")
var default_texture : Texture2D = preload("res://player/textures/Gurggu sprite sheet.png")
var interval_between_blinks: int = randi_range(210, 300)
var blinking_duration := 5

signal just_jumped()

@onready var dash_timer := $DashTimer
@onready var jump_buffer_timer := $JumpBufferTimer
@onready var water_jump_timer := $WaterJumpTimer
@onready var gurggu := $Gurggu
@onready var animation_player := $AnimationPlayer
@onready var water_detector := $WaterDetector
@onready var above_water_detector := $AboveWaterDetector
@onready var afterimage_spawner := $AfterimageSpawner

@onready var health : EntityHealth = $EntityHealth

var debug_mode_active: bool = false

enum STATE {
	MOVING,
	DASHING
}

var state: STATE = STATE.MOVING
var frozen: bool = false
var keep_moving: bool = true

func _ready() -> void:
	instance = self
	respawn_pos = position
	set_dash_outline()

func _physics_process(delta: float) -> void:
	# Debug stuff
	if Input.is_action_just_pressed("ui_focus_next") and debug_mode_active:
		health.health += 3
	if Input.is_action_just_pressed("ui_text_delete"):
		debug_mode_active = true if debug_mode_active == false else false
		velocity = Vector2.ZERO
		position = respawn_pos
	health.health = clamp(health.health, 0, 15)
	#print(velocity.y)
	
	update_shaders()
	set_dash_outline()
	
	if frozen:
		if keep_moving:
			if is_in_water():
				velocity.y = 14 # idk random number that just seems fine to add when dying in water
			else:
				velocity.y += gravity
			move_and_slide()
			return
		else:
			return
		
	
	first_time_in_air = !first_time_on_ground
	is_crouching = false
	if keep_dash_velocity:
		dash_speed += velocity.length() / 600.0
		dash_speed = clamp(dash_speed, DEFAULT_DASH_SPEED, 9999)
		keep_dash_speed = dash_speed
	else:
		dash_speed = DEFAULT_DASH_SPEED
	
	if (Input.is_action_just_pressed("jump") or is_jump_buffered):
		handle_jump()
	
	# Timers
	if last_dashed + reset_interval == GameTime.current_time:
		reverse_hyper_dash_leeway_time = false
	
	if last_activated_keep_dash_speed + keep_dash_speed_reset_interval == GameTime.current_time:
		deactivate_keep_dash_velocity()
	
	if coyote_time_start_time + coyote_time_duration == GameTime.current_time:
		coyote_time_wait_for_jump = false
	
	if last_left_water + WATER_JUMP_BUFFER_DURATION == GameTime.current_time:
		first_time_leaving_water = false
	#----#
	
	if !is_on_floor():
		if first_time_in_air:
			coyote_time_start_time = GameTime.current_time
			coyote_time_wait_for_jump = true
		first_time_on_ground = true
	
	if is_on_floor():
		on_floor()
	
	# Check if player's direction changed from last frame
	if player_direction != Vector2.ZERO:
		if int(player_direction.x) != last_movement_direction and first_time_changing_direction:
			has_player_direction_changed = true
			first_time_changing_direction = false
		else:
			has_player_direction_changed = false
			first_time_changing_direction = true
			
		last_movement_direction = int(player_direction.x)
	
	# Idk this shit is for turning and stuff the one above didn't work
	last_pressed_direction()
	
	# Movement
	match state:
		STATE.DASHING:
			if !is_dashing():
				state = STATE.MOVING
			
			# Buffer dash inputs
			if !is_dash_buffered and dash_timer.time_left >= (dash_duration - dash_buffer_time):
				velocity = Vector2.ZERO
				buffer_dash_inputs()
			else:
				if keep_dash_velocity:
					velocity = dash_speed * dash_direction
				else:
					velocity = dash_speed * dash_direction
	
		STATE.MOVING:
			is_dash_buffered = false
			
			# Gravity
			if !is_on_floor():
				if velocity.y > 0 and Input.is_action_pressed("move_down") and !keep_dash_velocity:
					velocity.y += fast_gravity
				else: 
					velocity.y += gravity
			
			player_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			if keep_dash_velocity:
				# Sign the value due to not wanting intercardinal directions registered
				player_direction = Vector2(sign(player_direction.x), 0)
			
			var velocity_weight: float = delta * (acceleration if player_direction.x else friction)
			if reverse_hyper_dash_leeway_time:
				keep_dash_speed_weight = 1.0 if is_on_floor() and reverse_hyper_dash_leeway_time and player_direction.x else 0.01
			
			# Check for downleft and downright inputs and reset movement to zero with lerp, else move player
			if (is_on_floor() and player_direction.y > 0) and player_direction.x:
				is_crouching = true
				velocity.x = lerpf(velocity.x, 0.0, velocity_weight)
				
			elif keep_dash_velocity:
				if (is_on_wall() and !reverse_hyper_dash_leeway_time) or (!is_on_floor() and has_player_direction_changed and !reverse_hyper_dash_leeway_time):
					deactivate_keep_dash_velocity()
					#print(abs(velocity.x) < keep_dash_speed_threshold)
				else:
					#print(velocity.x, "first velocity")
					if reset_velocity:
						velocity.x = 0.0
						keep_dash_speed_weight = 1.0
						reset_velocity = false
						#nothing happens cuz player direction = 0
					velocity.x = lerpf(velocity.x, sign(last_pressed_direction()) * keep_dash_speed, keep_dash_speed_weight)
					velocity.x *= 0.99
					#print(velocity.x)
					#print(last_pressed_direction(), "why how is 0")
					#print(keep_dash_speed_weight, "\n")
			else:
				velocity.x = lerpf(velocity.x, player_direction.x * SPEED, velocity_weight)
				#print("lerppi 2")
			if abs(velocity.x) < velocity_lerp_reset_threshold:
				velocity.x = 0
			
			# Clamped fall speed
			if velocity.y > max_fall_speed:
				velocity.y = max_fall_speed
			
			if Input.is_action_just_pressed("dash") and dash_count > 0 and GlobalVariables.has_dash:
				set_dash_outline()
				dash()
				state = STATE.DASHING
	
	
	# apply all environmental stuff after everything
	if is_in_water():
		while_in_water()
	else:
		if first_time_leaving_water and first_time_activating:
			last_left_water = GameTime.current_time
			first_time_activating = false
	
	
	set_player_flip_h()
	animate_player()
	
	# Add softcollision push after everything else
	velocity += SoftCollision.velocity_to_add
	#if SoftCollision.velocity_to_add.y > 0:
		#print(SoftCollision.velocity_to_add)
		#print(velocity, "velocity")
	SoftCollision.velocity_to_add = Vector2.ZERO
	position.round()
	move_and_slide()

func handle_jump() -> void:
	# Handle jump if dashing
	if is_dashing() and is_on_floor() and (is_jump_buffered or Input.is_action_just_pressed("jump")):
		dash_timer.stop()
		on_dash_timer_timeout()
	
	if first_time_leaving_water:
		if is_dashing():
			dash_timer.stop()
			on_dash_timer_timeout()
		jump()
		reset_dashes()
		first_time_leaving_water = false
		return
	
	# Coyote time
	if coyote_time_wait_for_jump:
		jump()
		coyote_time_wait_for_jump = false
		return
	
	if is_on_floor() or is_in_water():
		jump()
		
	else:
		if !is_jump_buffered:
			jump_buffer_timer.start(jump_buffer_duration)
			is_jump_buffered = true

func jump() -> void:
	is_jump_buffered = false
	just_jumped.emit()
	water_jump_timer.start(water_jump_time)
	velocity.y = jump_speed
	
	# If only pressed jump for a few frames in a buffer perform a small jump
	if !Input.is_action_pressed("jump"):
		velocity.y *= jump_height_cut

func _input(event: InputEvent) -> void:
	if event.is_action_released("jump"):
		# Cut the jump height
		if velocity.y < 0.0:
			velocity.y *= jump_height_cut

func _on_jump_buffer_timeout() -> void:
	is_jump_buffered = false

func on_dash_timer_timeout() -> void:
	if (is_jump_buffered or Input.is_action_just_pressed("jump")) and dash_direction.x != 0.0 and (is_on_floor() or is_in_water() or first_time_leaving_water):
		keep_dash_velocity = true
		reset_velocity = true
		# last time wavedashed to know when to disable it
		last_activated_keep_dash_speed = GameTime.current_time
	else:
		#print(velocity.x != 0)
		velocity = velocity.lerp(Vector2.ZERO, 0.5)
		deactivate_keep_dash_velocity()
		#another test lerp
		#velocity = lerp(DASH_SPEED, player_direction * SPEED, 0.1)
	last_dashed = GameTime.current_time
	reverse_hyper_dash_leeway_time = true
	afterimage_spawner.stop_spawning()
	state = STATE.MOVING

func is_dashing() -> bool:
	return !dash_timer.is_stopped()

func is_jumping() -> bool:
	return !water_jump_timer.is_stopped()

func buffer_dash_inputs() -> void:
	var buffered_dash_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if buffered_dash_direction == Vector2.ZERO:
		return
	if buffered_dash_direction != dash_direction:
		is_dash_buffered = true
	dash_direction = buffered_dash_direction

func dash() -> void:
	dash_count -= 1
	dash_direction = player_direction
	if player_direction == Vector2.ZERO:
		if last_pressed_direction() > 0:
			dash_direction = Vector2.RIGHT
		else:
			dash_direction = Vector2.LEFT
	
	dash_timer.start(dash_duration)
	
	afterimage_spawner.make_afterimage()
	afterimage_spawner.start_spawning()

func reset_dashes() -> void:
	dash_count = max_dashes
	set_dash_outline()

func while_in_water() -> void:
	first_time_leaving_water = true
	first_time_activating = true

	if Input.is_action_just_pressed("jump") or is_jump_buffered:
		if is_dashing():
			dash_timer.stop()
			on_dash_timer_timeout()
		is_jump_buffered = false
		handle_jump()
		
	if dash_timer.is_stopped():
		reset_dashes()
		
	if water_jump_timer.is_stopped() and !is_dashing():
		if abs(velocity.x) > SPEED:
			velocity.x = lerpf(velocity.x, sign(velocity.x) * WATER_SPEED, 0.05)
			#velocity.y -= 3
			velocity.y = clamp(velocity.y, max_fall_speed, 15)
		else:
			deactivate_keep_dash_velocity()
			velocity = velocity.lerp(player_direction * WATER_SPEED, 0.7)
		
	if water_jump_timer.is_stopped():
		velocity.y += water_gravity

func is_in_water() -> bool:
	return water_detector.has_overlapping_bodies()

func is_close_to_surface() -> bool:
	return !above_water_detector.has_overlapping_bodies()

func deactivate_keep_dash_velocity() -> void:
	if keep_dash_velocity:
		keep_dash_velocity = false
		dash_speed = DEFAULT_DASH_SPEED

func buffer_jump_direction() -> void:
	if player_direction != Vector2.ZERO:
		player_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func last_pressed_direction() -> float:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction.x != 0.0:
		last_pressed_input = direction.x
	
	return last_pressed_input

func on_floor() -> void:
	if first_time_on_ground:
		next_reset_time = GameTime.current_time
		first_time_on_ground = false

	if next_reset_time + reset_interval == GameTime.current_time:
		deactivate_keep_dash_velocity()
	
	if dash_timer.is_stopped():
		reset_dashes()

	if is_jump_buffered:
		jump()
		is_jump_buffered = false

func _die() -> void:
	# Stop the timer to stop the I-frames flashing
	health.iframes_timer.stop()
	health.monitoring = false
	frozen = true
	DeathScreen.instance._show_death_screen()

func _respawn() -> void:
	health.health = 5
	# Give a bit of invisibility
	health.iframes_timer.start(2.0)
	position = respawn_pos
	velocity = Vector2.ZERO
	SoftCollision.velocity_to_add = Vector2.ZERO
	health.monitoring = true
	frozen = false

func _take_damage(damage_amount: int = 1, teleport: bool = false) -> void:
	health.take_damage(damage_amount)
	frozen = true
	keep_moving = false
	await create_tween().tween_property(gurggu, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN).finished
	frozen = false
	
	if health.health <= 0:
		_die()
	elif teleport:
		velocity = Vector2.ZERO
		position = respawn_pos
		keep_moving = true
	await create_tween().tween_property(gurggu, "modulate:a", 1.0, 0.2).set_ease(Tween.EASE_OUT).finished

func animate_player() -> void:
	if !is_zero_approx(velocity.x):
		animation_player.play("walk")
	
	if !animation_player.is_playing():
		animation_player.play("idle")
	
	# jump & fall
	if velocity.y > 0:
		animation_player.play("falling")

	if velocity.y < 0:
		animation_player.play("falling_up")
	
	# Blink
	if interval_between_blinks != 0:
		interval_between_blinks -= 1
	else:
		gurggu.texture.set_diffuse_texture(blinking_texture)
		blinking_duration -= 1
		if blinking_duration == 0:
			gurggu.texture.set_diffuse_texture(default_texture)
			
			set_dash_outline()
			blinking_duration = 5
			interval_between_blinks = randi_range(210, 300)
	
	if !health.iframes_timer.is_stopped():
		gurggu.modulate.g = 0.9 if Engine.get_frames_drawn() % 2 == 0 else 1.0
	else:
		gurggu.modulate.g = 1.0

func update_shaders() -> void:
	gurggu.material.set_shader_parameter("modulate", gurggu.modulate * gurggu.self_modulate)

func set_dash_outline() -> void:
	if dash_count > 0 and GlobalVariables.has_dash:
		gurggu.material.set_shader_parameter("new", Color(0.263, 0.518, 0.016))
	else:
		gurggu.material.set_shader_parameter("new", Color(0.161, 0.247, 0.129))

func set_player_flip_h() -> void:
	if last_pressed_direction() > 0:
		gurggu.flip_h = true
	elif last_pressed_direction() == 0:
		gurggu.flip_h = true if last_pressed_input > 0 else false
	else:
		gurggu.flip_h = false
