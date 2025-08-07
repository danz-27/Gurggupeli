extends CharacterBody2D

var move_speed := 128
var jump_speed := -400.0
var dash_speed := 256
var gravity := 1000
var dash_count := 1
@onready var dash_duration := $Timer

func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	
	
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = jump_speed
	
	
	if is_on_floor():
		dash_count = 1
	else:
		velocity.y += gravity / 60
	
	velocity.x *= 0.75
	if velocity.x < 0.1:
		velocity.x = 0
	
	move_player()
	set_player_flip_h()
	animate_player()
	print("velocity ", velocity)
	print("gravity ", gravity)
	move_and_slide()

#varied jump height
func _input(event):
	if event.is_action_released("jump"):
		if velocity.y < 0.0:
			velocity.y *= 0.5

func move_player() -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

	if (direction == Vector2.RIGHT || direction == Vector2.LEFT):
		check_dash(direction)
		velocity.x = direction.x * move_speed
		
	if direction.x > 0 && direction.y < 0: #UPRIGHT
		check_dash(direction)
		velocity.x = move_speed
		
	if direction.x < 0 && direction.y < 0: #UPLEFT
		check_dash(direction)
		velocity.x = -move_speed
	
	if direction.x > 0 && direction.y > 0: #DOWNRIGHT
		check_dash(direction)
		velocity.x = move_speed
	
	
	
		
		
func check_dash(dash_direction: Vector2) -> void:
	var fixed_dash_direction = dash_direction
	if !dash_duration.is_stopped():
		velocity = fixed_dash_direction * dash_speed
		return
		
	if dash_duration.is_stopped():
		gravity = 1000
		
	if Input.is_action_just_pressed("dash") && dash_count > 0:
		dash_count -= 1
		velocity = Vector2.ZERO
		dash_duration.start(0.4)
		velocity = dash_direction * dash_speed




func animate_player() -> void:
	
	#walk right & left
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
	
