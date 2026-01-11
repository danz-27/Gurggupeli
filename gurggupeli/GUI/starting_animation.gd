extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var main_menu: Control = $"../MainMenu"
@export var curve: Curve

@onready var vignette: PointLight2D = $Vignette

func _physics_process(_delta: float) -> void:
	if animation_player.is_playing() and Input.is_action_just_pressed("escape"):
		_on_animation_player_animation_finished("starting animation")
		animation_player.stop()
		Player.instance.frozen = true
	

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	#vignette.position = Player.instance.global_position
	vignette.show()
	await get_tree().create_tween().tween_property(vignette, "energy", 250.0, 4.0).finished
	$"starting animation".hide()
	main_menu.visible = false
	OptionsMenu.instance.is_on_pause_menu = true
	GlobalVariables.anim_played = true
	for i in range(50):
		await get_tree().physics_frame
	Player.instance.frozen = false
	await get_tree().create_tween().tween_property(vignette, "energy", 0.7, 7.0).set_custom_interpolator(tween_curve).finished
	
	hide()

func tween_curve(offset: float) -> float:
	return curve.sample_baked(offset)
