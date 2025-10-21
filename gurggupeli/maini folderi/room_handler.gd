extends Node2D
class_name RoomHandler

static var instance: RoomHandler

func _ready() -> void:
	instance = self

func _set_current_room(room: PackedScene, spawn_pos: Vector2) -> void:
	for child in get_children():
		child.queue_free()
	
	for child in EntitiesContainer.instance.get_children():
		child.queue_free()
	add_child.call_deferred(room.instantiate())
	Player.instance.position = spawn_pos
