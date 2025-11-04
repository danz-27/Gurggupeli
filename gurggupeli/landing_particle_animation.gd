extends Sprite2D

func _ready() -> void:
	$AnimationPlayer.play("LandingAnimation")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
