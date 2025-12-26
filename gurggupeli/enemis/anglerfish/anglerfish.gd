extends Entity

@onready var animation := $Sprite2D/AnimationPlayer
@onready var mouth_detection := $"Sprite2D/Mouth area"
var attacking: bool = false
var player_in_mouth: bool = false
var player_in_mouth_timer: int = 0

func _ready() -> void:
	animation.play("swim_mouth_closed")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !attacking:
		attacking = true
		var tween1: Tween = get_tree().create_tween()
		tween1.set_ease(Tween.EASE_IN_OUT)
		tween1.tween_property($Sprite2D, "global_position", $Area2D/CollisionShape2D.global_position, 0.3)
		tween1.finished.connect(on_tween1_finished)
		animation.play("open_mouth")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "open_mouth":
		animation.play("swim_mouth_opened")
	elif anim_name == "close_mouth":
		animation.play("swim_mouth_closed")
		var tween2: Tween = get_tree().create_tween()
		tween2.tween_property($Sprite2D, "global_position", self.position, 2.0)
		tween2.finished.connect(on_tween2_finished)

func on_tween1_finished() -> void:
	animation.play("close_mouth")
	
func on_tween2_finished() -> void:
	attacking = false

func _on_mouth_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_mouth = true
		
func spit_out(body: Player) -> void:
	player_in_mouth = false
	body.visible = true
	body.velocity += Vector2(-1000 * scale.x, 0)

func _physics_process(_delta: float) -> void:
	for body: Player in mouth_detection.get_overlapping_bodies():
		if player_in_mouth:
			body.instance.visible = false
			body.instance.global_position = $"Sprite2D/Mouth area/CollisionShape2D".global_position
			player_in_mouth_timer += 1
			if player_in_mouth_timer > 100:
				player_in_mouth_timer = 0
				spit_out(body)
