extends TextureRect


@onready var respawn_button := $RespawnButton
@onready var exit_button := $ExitButton

func _ready() -> void:
	pass


func _on_respawn_button_pressed() -> void:
	visible = false
	Player.instance.position = Player.instance.respawn_pos
	# Wait a few frames after respawning to not bug out health
	for i in range (1, 5):
		await get_tree().physics_frame
	Player.instance.health.health = 5



func _on_exit_button_pressed() -> void:
	pass # Replace with function body.
