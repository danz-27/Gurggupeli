extends Node2D
@onready var line2D: Line2D = $Line2D

func _ready() -> void:
	for segment: RigidBody2D in get_children().filter(func(node: Node2D) -> bool: return node is RigidBody2D):
		segment.linear_damp = 3.0
		#segment.linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE

func _physics_process(_delta: float) -> void:
	var points: Array[Vector2] = []
	for segment: RigidBody2D in get_children().filter(func(node: Node2D) -> bool: return node is RigidBody2D):
		#segment.linear_velocity = segment.linear_velocity.clamp(Vector2(0.0, 0.0), Vector2(30.0, 30.0)) 
		if segment.linear_velocity.length() >= 40:
			segment.linear_velocity.x = 40
			segment.linear_velocity.y = 40
		for joint: PinJoint2D in segment.get_children().filter(func(node: Node2D) -> bool: return node is PinJoint2D):
			points.append(joint.global_position - line2D.global_position)
	@warning_ignore("untyped_declaration")
	var smooth_points = catmull_rom_spline(points)
	line2D.points = smooth_points


func catmull_rom_spline(
	_points: Array, resolution: int = 10, extrapolate_end_points: bool = true
) -> PackedVector2Array:
	@warning_ignore("untyped_declaration")
	var points = _points.duplicate()
	if extrapolate_end_points:
		points.insert(0, points[0] - (points[1] - points[0]))
		points.append(points[-1] + (points[-1] - points[-2]))

	var smooth_points := PackedVector2Array()
	if points.size() < 4:
		return points

	for i in range(1, points.size() - 2):
		@warning_ignore("untyped_declaration")
		var p0 = points[i - 1]
		@warning_ignore("untyped_declaration")
		var p1 = points[i]
		@warning_ignore("untyped_declaration")
		var p2 = points[i + 1]
		@warning_ignore("untyped_declaration")
		var p3 = points[i + 2]

		for t in range(0, resolution):
			@warning_ignore("untyped_declaration")
			var tt = t / float(resolution)
			@warning_ignore("untyped_declaration")
			var tt2 = tt * tt
			@warning_ignore("untyped_declaration")
			var tt3 = tt2 * tt

			@warning_ignore("untyped_declaration")
			var q = (
				0.5
				* (
					(2.0 * p1)
					+ (-p0 + p2) * tt
					+ (2.0 * p0 - 5.0 * p1 + 4 * p2 - p3) * tt2
					+ (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * tt3
				)
			)

			smooth_points.append(q)

	return smooth_points
