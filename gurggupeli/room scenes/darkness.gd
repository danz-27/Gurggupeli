class_name DynamicSemiTransparency extends TileMapLayer

var player: CharacterBody2D = Player.instance

func _physics_process(_delta: float) -> void:
	if player:
		material.set_shader_parameter("player_position", player.global_position)
