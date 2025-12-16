extends Node2D

var opened: bool = false
var is_inside_detection_area: bool = false
	
func manhole_opened() -> void:
	#print("Mandhole open called")
	for child in get_children():
		if child.has_method("_activate"):
			child._activate()

func _physics_process(_delta: float) -> void:
	if is_inside_detection_area and Input.is_action_just_pressed("interact") and !opened:
		manhole_opened()
		$ManholeCoverAnimationSpritesheet/AnimationPlayer.play("open")
		opened = true

func _on_area_2d_body_entered(_body: Node2D) -> void:
	is_inside_detection_area = true
	$InteractPopup.scale = Vector2(0.5, 0.5)
	$InteractPopup.global_position = $Area2D/CollisionShape2D.global_position + 20 * Vector2.UP 
	if $StaticBody2D/CollisionShape2D.disabled == true:
		pass
	else:
		$InteractPopup.show()

func _on_area_2d_body_exited(_body: Node2D) -> void:
	is_inside_detection_area = false
	$InteractPopup.hide()

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	$StaticBody2D/CollisionShape2D.disabled = true
