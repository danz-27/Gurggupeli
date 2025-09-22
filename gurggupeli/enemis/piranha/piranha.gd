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

var state : STATE = STATE.ROAM
var spawn_pos : Vector2 
var roam_pos : Vector2
const ROAM_THRESHOLD := 1
const CHASE_THRESHOLD := 100
const CHASE_SPEED := 100
const ROAM_SPEED := 50

@onready var sprite : Sprite2D = $Sprite2D
@onready var raycast : RayCast2D = $RayCast2D

func _physics_process(_delta: float) -> void:
	var player_pos : Vector2 = Player.instance.position
	raycast.target_position = player_pos - position
	match state:
		STATE.CHASE:
			velocity = position.direction_to(player_pos) * CHASE_SPEED
	
			if position.distance_to(player_pos) > CHASE_THRESHOLD or raycast.is_colliding() or !Player.instance.is_in_water():
				state = STATE.ROAM
				roam_pos = spawn_pos
	
		STATE.ROAM:
			if position.distance_to(roam_pos) < ROAM_THRESHOLD:
				recalculate_roam_pos()
	
			velocity = position.direction_to(roam_pos) * ROAM_SPEED
	
			if position.distance_to(player_pos) < CHASE_THRESHOLD and !raycast.is_colliding() and Player.instance.is_in_water():
				state = STATE.CHASE
	
	sprite.flip_h = velocity.x > 0
	var collided := move_and_slide()
	if collided and is_on_wall():
		recalculate_roam_pos()

func recalculate_roam_pos() -> void:
	if spawn_pos.x < roam_pos.x:
		roam_pos = spawn_pos + Vector2(-100, 0)
	else:
		roam_pos = spawn_pos + Vector2(100, 0)
