extends Node2D

var currently_activated: bool = false
var is_inside_detection_area: bool = false

@onready var path: String = get_path()
	
func _ready() -> void:
	if GlobalVariables.activated_interactables.has(path):
		var tween: Tween = $Valve_sprite.create_tween()
		tween.tween_property($Valve_sprite, "rotation", PI, 1)
		valve_activated()
		currently_activated = true
	
func valve_activated() -> void:
	if !(GlobalVariables.activated_interactables.has(path)):
		GlobalVariables.activated_interactables.append(path)
	for child in get_children():
		if child.has_method("_activate"):
			child._activate()
			
func valve_deactivated() -> void:
	if GlobalVariables.activated_interactables.has(path):
		GlobalVariables.activated_interactables.erase(path)
	for child in get_children():
		if child.has_method("_deactivate"):
			child._deactivate()

func _physics_process(_delta: float) -> void:
	if is_inside_detection_area and Input.is_action_just_pressed("interact"):
		if !currently_activated:
			var tween: Tween = $Valve_sprite.create_tween()
			tween.tween_property($Valve_sprite, "rotation", PI, 1)
			valve_activated()
			currently_activated = true
		else:
			var tween: Tween = $Valve_sprite.create_tween()
			tween.tween_property($Valve_sprite, "rotation", 0, 1)
			valve_deactivated()
			currently_activated = false


func _on_area_2d_body_entered(_player: Node2D) -> void:
	is_inside_detection_area = true
	$InteractPopup.global_position.y = $Area2D.global_position.y - 20
	$InteractPopup.show()

func _on_area_2d_body_exited(_player: Node2D) -> void:
	is_inside_detection_area = false
	$InteractPopup.hide()
