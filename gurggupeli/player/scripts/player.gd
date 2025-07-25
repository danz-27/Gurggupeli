extends CharacterBody2D

var speed := 32
var jump_speed := -400.0
var jump_amount := 1

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	pass
	

func _physics_process(_delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity / 60
		
	#jump & doublejump
	if Input.is_action_just_pressed("jump") and jump_amount > 0:
		jump_amount -= 1
		velocity.y = jump_speed
		
	if is_on_floor() and jump_amount != 1:
		jump_amount = 1
	print(velocity.y)
	#movement left & right
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	
	#print(velocity)
	
	set_player_flip_h()
	animate_player()
	move_and_slide()
	
	

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
	


 
