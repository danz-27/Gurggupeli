extends Node2D
class_name RoomHandler

static var instance: RoomHandler

func _ready() -> void:
	instance = self

func _set_current_room(room: PackedScene, spawn_pos: Vector2) -> void:
	LoadingScreen.enabled = true
	if LoadingScreen.fade_completed:
		for child in get_children():
			child.queue_free()
		
		for child in EntitiesContainer.instance.get_children():
			child.queue_free()
		
		LoadingScreen.fade_completed = false
	add_child.call_deferred(room.instantiate())
	Player.instance.position = spawn_pos
