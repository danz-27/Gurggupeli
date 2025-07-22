extends Area2D

@export var speed = 32 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play("walk")
	elif $AnimatedSprite2D.animation != &"walk" or not $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.play("default")
		
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x > 0
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	
		
