extends CharacterBody2D

var speed := 32
var jump_speed := -400.0


var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	pass
	
	
func _physics_process(delta: float) -> void:
	
	velocity.y += gravity / 60
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed

	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	
	print(velocity)
	
	set_player_flip_h()
	animate_player()
	move_and_slide()
	
	

func animate_player() -> void:
	
	if velocity.x != 0:
		$AnimationPlayer.play("walk")

	elif not ($AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "walk"):
		$AnimationPlayer.play("idle")


func set_player_flip_h() -> void:
	
	if velocity.x != 0:
		$Gurggu.flip_h = velocity.x > 0
	


 
