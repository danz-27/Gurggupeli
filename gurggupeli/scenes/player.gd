extends CharacterBody2D

var speed = 32
var jump_speed = -400.0
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var gurggu_flip_x = 0
# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	state_machine.travel("default")

func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed

	# Get the input direction.
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	if direction == -1:
		gurggu_flip_x = false
	elif direction == 1:
		gurggu_flip_x = true
		
	$"Gurggu".flip_h = gurggu_flip_x
	print(velocity)
	
	if direction == 0:
		state_machine.travel("default")
	else:
		state_machine.travel("walk")
		
	move_and_slide()
