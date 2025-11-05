extends Entity
class_name Rat

enum STATE {
	ROAM,
	CHASE
}

var state: STATE = STATE.CHASE
var jump_strenght: int = 200
var up_amount: Vector2 = Vector2.UP * 65
var min_amount_between_jumps: int = 30
var grounded_frames: int = 0
var gravity: int = 4
var jump_up_next: bool = false
var backing_up: bool = false
const CHASE_THRESHOLD: int = 100

@onready var raycast: RayCast2D = $RayCast2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rotta: Sprite2D = $Sprite2D

func _physics_process(_delta: float) -> void:
	if !jump_up_next:
		raycast.target_position = (Player.instance.global_position - position) + up_amount
	
	match state:
		STATE.CHASE:
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
					raycast.target_position = (Player.instance.global_position - position) + up_amount * 200
					jump_up_next = true
					
			else:
				grounded_frames = 0
				
			#if position.distance_to(Player.instance.global_position) > CHASE_THRESHOLD or raycast.is_colliding() or Player.instance.is_in_water():
				#state = STATE.ROAM
		
		STATE.ROAM:
			animation_player.play("Run")
			if rotta.flip_h and !backing_up:
				velocity.x -= 1
			else:
				velocity.x += 1
			
			if is_on_wall():
				
				if rotta.flip_h:
					velocity.x -= 25 
				else:
					velocity.x += 25
				
			if position.distance_to(Player.instance.global_position) < CHASE_THRESHOLD and !raycast.is_colliding() and !Player.instance.is_in_water():
				state = STATE.CHASE
	
	velocity.x += sign(raycast.target_position.x)
	velocity.y = lerp(velocity.y, velocity.y + gravity, 0.9)
	#print(velocity)
	rotta.flip_h = true if velocity.x > 0 else false
	move_and_slide()
