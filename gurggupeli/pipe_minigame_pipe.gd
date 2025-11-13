extends Node2D
	
class pipe:
	var shapes: Array = ["straight", "left_turn", "right_turn"]
	var shape: String = shapes.pick_random() #can be "straight", "left_turn", "right_turn"
	var direction: int = randi_range(0,3)
	
	func get_pipe_hole_directions() -> Array:
		if shape == "straight":
			return [direction, (direction+2) % 4]
		elif shape == "left_turn":
			return [direction, (direction+1) % 4]
		elif shape == "right_turn":
			return [direction, (direction+3) % 4]
		else:
			return []

var class_pipe_instance: pipe = pipe.new()
var position_in_array: int

func set_frame(shape: String) -> void:
	var frames: Dictionary = {
	"straight" : 2,
	"left_turn" : 1,
	"right_turn" : 0}
	$Sprite2D.frame = frames[shape]

func _ready() -> void:
	set_frame(class_pipe_instance.shape)
	$Sprite2D.rotation = class_pipe_instance.direction * PI/2 + PI


func _on_button_pressed() -> void:
	get_parent().pipes[get_parent().pipes.find(self)].class_pipe_instance.direction = (class_pipe_instance.direction+1) % 4
	if get_parent().check_for_win([0, 2], [5, 2]):
		get_parent().won = true
	else:
		get_parent().won = false
	position_in_array = get_parent().pipes.find(self)
	$Sprite2D.rotation = class_pipe_instance.direction * PI/2 + PI
