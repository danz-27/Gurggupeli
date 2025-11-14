extends Node2D
class_name pipe

static var class_pipe_instance : pipe

var starting_position: Array = [-1, 2]
var ending_position: Array = [10, 2]

var shapes: Array = ["straight", "turn", "4-way_cross"]
var shape: String = shapes.pick_random()
var direction: int = randi_range(0,3)

@onready var agent_texture: Sprite2D = $agent
var has_agent: bool = false

func get_pipe_hole_directions() -> Array:
	if shape == "straight":
		return [direction, (direction+2) % 4]
	elif shape == "turn":
		return [direction, (direction+1) % 4]
	elif shape == "4-way_cross":
		return [direction, (direction+2) % 4, (direction+1) % 4, (direction+3) % 4]
	else:
		return []

var position_in_array: int

func update_position_in_array() -> void:
	position_in_array = get_parent().pipes.find(self)

func set_frame(own_shape: String) -> void:
	var frames: Dictionary = {
	"straight" : 2,
	"turn" : 1,
	"4-way_cross" : 5}
	$Sprite2D.frame = frames[own_shape]

func _ready() -> void:
	set_frame(shape)
	$Sprite2D.rotation = direction * PI/2 + PI


func _on_button_pressed() -> void:
	if !get_parent().locked:
		get_parent().pipes[get_parent().pipes.find(self)].direction = (direction+1) % 4
		if get_parent().check_for_win(starting_position, ending_position, 1):
			get_parent().won = true
		else:
			get_parent().won = false
		position_in_array = get_parent().pipes.find(self)
		$Sprite2D.rotation = direction * PI/2 + PI

func _physics_process(_delta: float) -> void:
	if has_agent:
		agent_texture.visible = true
	else:
		agent_texture.visible = false
