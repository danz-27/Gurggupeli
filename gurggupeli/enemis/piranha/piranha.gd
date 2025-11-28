extends Entity
class_name Piranha

static func create(pos: Vector2) -> Piranha:
	var piranha : Piranha = preload("res://enemis/piranha/piranha.tscn").instantiate()
	piranha.spawn_pos = pos
	piranha.position = pos
	piranha.roam_pos = pos
	EntitiesContainer.add(piranha)
	return piranha

enum STATE {
	ROAM,
	CHASE
}

var is_girly_pop : bool = (randi_range(1, 100) > 99)
var state : STATE = STATE.ROAM
var spawn_pos : Vector2 
var roam_pos : Vector2
const ROAM_THRESHOLD := 1
const CHASE_THRESHOLD := 200
const CHASE_SPEED := 3
const ROAM_SPEED := 1
const MAX_SPEED := 200
var state_switch_timer: int = 0
var required_duration: int = 60

@onready var sprite : Sprite2D = $Sprite2D
@onready var rusetti : Sprite2D = $Sprite2D/Rusetti
@onready var raycast : RayCast2D = $RayCast2D
@onready var animation_player := $AnimationPlayer
@onready var water_detector: Area2D = $WaterDetector

func _ready() -> void:
	if is_girly_pop:
		#print("im girly")
		rusetti.visible = true

func _physics_process(_delta: float) -> void:
	var player_pos : Vector2 = Player.instance.position

	if position.distance_to(player_pos) <= CHASE_THRESHOLD:
		raycast.target_position = player_pos - position
		raycast.enabled = true
	else:
		raycast.enabled = false
		
	match state:
		STATE.CHASE:
			animation_player.play("agressive")
			if Player.instance.is_close_to_surface():
				velocity += position.direction_to(player_pos + Vector2.DOWN * 10) * CHASE_SPEED
			else:
				velocity += position.direction_to(player_pos) * CHASE_SPEED
				
			if position.distance_to(player_pos) > CHASE_THRESHOLD or raycast.is_colliding() or !Player.instance.is_in_water():
				state_switch_timer += 1
				if state_switch_timer == required_duration:
					state = STATE.ROAM
					roam_pos = spawn_pos
					# Lerp velocity to slow down the piranha after switching
					velocity = lerp(velocity, velocity * 0.1, 0.5)
					# ADD THE QUESTIONMARK HERE
					state_switch_timer = 0
			else:
				state_switch_timer = 0
			
		STATE.ROAM:
			animation_player.play("passive")
			if position.distance_to(roam_pos) < ROAM_THRESHOLD:
				recalculate_roam_pos()
			
			velocity += position.direction_to(roam_pos) * ROAM_SPEED
			
			if position.distance_to(player_pos) < CHASE_THRESHOLD and !raycast.is_colliding() and Player.instance.is_in_water():
				state = STATE.CHASE
	
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	if !is_in_water():
		velocity.y += 8
	sprite.flip_h = velocity.x > 0
	rusetti.flip_h = velocity.x > 0
	var collided := move_and_slide()
	if collided and is_on_wall():
		recalculate_roam_pos()

func recalculate_roam_pos() -> void:
	if spawn_pos.x < roam_pos.x:
		roam_pos = spawn_pos + Vector2(-100, 0)
	else:
		roam_pos = spawn_pos + Vector2(100, 0)

func is_in_water() -> bool:
	return water_detector.has_overlapping_bodies()

func _die() -> void:
	get_parent().queue_free()
