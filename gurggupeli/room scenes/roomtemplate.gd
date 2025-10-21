extends Node2D

@onready var exits: Dictionary[String, Area2D] = {
	"RIGHT": $EntranceRight
}

var exit_scenes: Dictionary[String, PackedScene] = {
	"RIGHT": load("res://room scenes/otter_dimension.tscn")
}

var spawn_locations: Dictionary[String, Vector2] = {
	"RIGHT": Vector2(50, -20)
}

func _on_enter_entrance_right(_player: Node2D) -> void:
	RoomHandler.instance._set_current_room(exit_scenes["RIGHT"], spawn_locations["RIGHT"])
