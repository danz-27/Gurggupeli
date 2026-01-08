extends Node2D

@onready var sprite: Node = $Sprite2D
@export var vile_tag: String

func _ready() -> void:
	if GlobalVariables.collected_viles.has(vile_tag):
		sprite.visible = false
	var tween: Tween = get_tree().create_tween()
	tween.set_loops(9999)
	tween.tween_property(sprite, "position", Vector2(0, -2), 3).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "position", Vector2(0, 2), 3).set_ease(Tween.EASE_IN_OUT)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if !GlobalVariables.collected_viles.has(vile_tag):
			get_tree().call_group("inventory", "_add_vile")
			GlobalVariables.collected_viles.append(vile_tag)
			sprite.visible = false
