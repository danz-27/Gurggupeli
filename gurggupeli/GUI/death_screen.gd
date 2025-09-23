extends TextureRect


@onready var respawn_button := $RespawnButton
@onready var exit_button := $ExitButton

func _ready() -> void:
	pass


func _on_respawn_button_pressed() -> void:
	visible = false
	Player.instance.position = Player.instance.respawn_pos
	Player.instance.health.health = 15



func _on_exit_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
