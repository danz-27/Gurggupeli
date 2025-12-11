extends Node2D

var opened: bool = false
var is_inside_detection_area: bool = false
	
func manhole_opened() -> void:
	print("Mandhole open called")
	for child in get_children():
		if child.has_method("_activate"):
			child._activate()

func _physics_process(_delta: float) -> void:
	if is_inside_detection_area and Input.is_action_just_pressed("interact") and !opened:
		manhole_opened()
		$ManholeCoverAnimationSpritesheet/AnimationPlayer.play("open")
		opened = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	is_inside_detection_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	print(body)
	is_inside_detection_area = false


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	$StaticBody2D/CollisionShape2D.disabled = true
