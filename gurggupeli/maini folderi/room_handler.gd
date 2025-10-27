extends Node2D
class_name RoomHandler

static var instance: RoomHandler

var rooms: Array[Node]
var entities: Array[Node]
var loaded_room: Node2D
var player_spawn_pos: Vector2
func _ready() -> void:
	instance = self

func _set_current_room(room: PackedScene, spawn_pos: Vector2) -> void:
	LoadingScreen.enabled = true
	loaded_room = room.instantiate()
	player_spawn_pos = spawn_pos
	
	for child in get_children():
		rooms.append(child)
	for child in EntitiesContainer.instance.get_children():
		entities.append(child)

func _physics_process(_delta: float) -> void:
	if LoadingScreen.instance.fade_complete:
		for room in rooms:
			room.queue_free()
		rooms = []
		for entity in EntitiesContainer.instance.get_children():
			entity.queue_free()
		entities = []
		add_child.call_deferred(loaded_room)
		Player.instance.position = player_spawn_pos
		LoadingScreen.instance.fade_complete = false
