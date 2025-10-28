extends Node2D

var valve_children : Array = []
var currently_activated : bool = false
var is_inside_detection_area : bool = false

func get_all_children(node) -> Array:
	var nodes : Array = []
	for N in node.get_children():
		nodes.append(N)
	return nodes
	
func valve_activated() -> void:
	valve_children = get_all_children(self)
	for n in valve_children:
		if n.has_method("activate"):
			n.activate()
			
func valve_deactivated() -> void:
	valve_children = get_all_children(self)
	for n in valve_children:
		if n.has_method("deactivate"):
			n.deactivate()
	
func _ready() -> void:
	return

func _physics_process(_delta: float) -> void:
	if is_inside_detection_area and Input.is_action_just_pressed("interact"):
		if !currently_activated:
			var tween = $Valve_sprite.create_tween()
			tween.tween_property($Valve_sprite,"rotation",PI,1)
			valve_activated()
			currently_activated = true
		else:
			var tween = $Valve_sprite.create_tween()
			tween.tween_property($Valve_sprite,"rotation",0,1)
			valve_deactivated()
			currently_activated = false


func _on_area_2d_body_entered(_player: Node2D) -> void:
	is_inside_detection_area = true


func _on_area_2d_body_exited(_player: Node2D) -> void:
	is_inside_detection_area = false
