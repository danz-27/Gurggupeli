extends TextureRect
class_name DeathScreen

static var instance: DeathScreen

@onready var respawn_button := $RespawnButton
@onready var exit_button := $ExitButton

func _ready() -> void:
	modulate.a = 0.0
	visible = false
	instance = self

func _show_death_screen() -> void:
	var show_screen: PropertyTweener = create_tween().tween_property(self, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_OUT)
	
	show_screen.finished.connect(set_visibility.bind(true))
	#await show_screen.finished

func _on_respawn_button_pressed() -> void:
	var un_show_screen: PropertyTweener = create_tween().tween_property(self, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN)
	
	un_show_screen.finished.connect(set_visibility.bind(false))
	#await un_show_screen.finished
	
	# Wait a few frames after respawning to not bug out health
	for i in range(5):
		await get_tree().physics_frame
	Player.instance._respawn()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func set_visibility(state: bool) -> void:
	visible = state
