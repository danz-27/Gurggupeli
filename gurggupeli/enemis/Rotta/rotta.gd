extends Entity
class_name Rat

static func create(pos: Vector2) -> Rat:
	var rat: Rat = preload("res://enemis/Rotta/rotta.tscn").instantiate()
	rat.spawn_pos = pos
	rat.position = pos
	rat.roam_pos = pos
	EntitiesContainer.add(rat)
	return rat

enum STATE {
	ROAM,
	CHASE
}

var spawn_pos : Vector2 
var roam_pos : Vector2
var state: STATE = STATE.CHASE
var jump_strenght: int = 200
var up_amount: Vector2 = Vector2.UP * 65
var min_amount_between_jumps: int = 30
var grounded_frames: int = 0
var gravity: int = 4
var jump_up_next: bool = false
var backing_up: bool = false
var jump: bool = true
var move_threshold: float
var state_switch_timer: int
var required_duration: int = 60
const CHASE_THRESHOLD: int = 125
const ROAM_SPEED: int = 1
const ROAM_THRESHOLD: int = 1

@onready var raycast: RayCast2D = $RayCast2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rotta: Sprite2D = $Sprite2D
@export var left_roam_pos_distance: float = 60.0
@export var right_roam_pos_distance: float = 60.0


func _physics_process(_delta: float) -> void:
	var player_pos: Vector2 = Player.instance.global_position
	
	match state:
		STATE.CHASE:
			if !jump_up_next:
				raycast.target_position = (player_pos - position) + up_amount
				velocity.x += sign(raycast.target_position.x)
			
			if is_on_floor():
				grounded_frames += 1
				animation_player.play("Angry_run")
				
				if grounded_frames == min_amount_between_jumps:
					animation_player.stop()
					velocity = velocity.lerp(velocity.direction_to(raycast.target_position) * jump_strenght, 0.5) * randf_range(1, 2)
					jump_up_next = false
					if is_on_wall():
						velocity = velocity.lerp(velocity.direction_to(raycast.target_position) * jump_strenght, 0.5)
				
				if is_on_wall():
					if rotta.flip_h:
						velocity.x -= 20
					else:
						velocity.x += 20
					raycast.target_position = (player_pos - position) + up_amount * 200
					jump_up_next = true
					
			else:
				if velocity.angle() > 0 and velocity.angle() < PI: # Check if falling or going up and set animation based on that
					rotta.frame = 11
				else:
					rotta.frame = 9
				grounded_frames = 0
			
			if (
				position.distance_to(player_pos) > CHASE_THRESHOLD# or 
				# Check if rat is below or under the player to move the rat to right or left
				#(position.angle_to(Vector2(1.0, -1.0)) < position.angle_to(player_pos) and position.angle_to(Vector2(-1.0, -1.0)) < position.angle_to(player_pos)) or 
				#(position.angle_to(Vector2(1.0, 1.0)) < position.angle_to(player_pos) and position.angle_to(Vector2(-1.0, 1.0)) < position.angle_to(player_pos))
				):
				state_switch_timer += 1
				if state_switch_timer == required_duration:
					state = STATE.ROAM
					roam_pos = spawn_pos
					# Lerp velocity to slow down the rat after switching
					velocity = lerp(velocity, velocity * 0.1, 0.5)
					# ADD THE QUESTIONMARK HERE
					state_switch_timer = 0
			else:
				state_switch_timer = 0
		STATE.ROAM:
			animation_player.play("Run")
			
			if is_on_wall():
				velocity.x = 0.0
				backing_up = true
				if roam_pos.x > 0:
					velocity.x -= 8
				else:
					velocity.x += 8
				if jump:
					jump = false
					get_tree().create_timer(0.6).timeout.connect(_call_this)
			
			if abs(position.x - roam_pos.x) < ROAM_THRESHOLD:
				recalculate_roam_pos()
			
			if !backing_up:
				velocity += position.direction_to(roam_pos) * ROAM_SPEED
			
			velocity.x = clamp(velocity.x, -20, 20)
			if position.distance_to(player_pos) < CHASE_THRESHOLD:
				state = STATE.CHASE
	
	
	velocity.y = lerp(velocity.y, velocity.y + gravity, 0.9)
	#print(position)
	rotta.flip_h = true if velocity.x > 0 else false
	move_and_slide()

func recalculate_roam_pos() -> void:
	if spawn_pos.x < roam_pos.x:
		roam_pos = spawn_pos + Vector2.LEFT * left_roam_pos_distance
		#print("LEFT")
	else:
		roam_pos = spawn_pos + Vector2.RIGHT * right_roam_pos_distance
		#print("RIGHT")

func _call_this() -> void:
	#print("Called this")
	backing_up = false
	jump = true
	if is_on_floor():
		velocity += velocity.lerp(velocity.direction_to(roam_pos + Vector2.UP * 1000) * 200, 0.5)
	#print(roam_pos)
