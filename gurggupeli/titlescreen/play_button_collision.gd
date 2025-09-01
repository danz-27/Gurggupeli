extends CollisionShape2D

func _physics_process(delta):
	# get the Physics2DDirectSpaceState object
	var space = get_world_2d().direct_space_state
	# Get the mouse's position
	var mousePos = get_global_mouse_position()
	# Check if there is a collision at the mouse position
	if space.intersect_point(mousePos, 1):
		print("hit something")
	else:
		print("no hit")
