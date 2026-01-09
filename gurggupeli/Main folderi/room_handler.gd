extends Node2D
class_name RoomHandler

static var instance: RoomHandler

var rooms: Array[Node]
var entities: Array[Node]

func _ready() -> void:
	instance = self

func _change_room(next_room: Node2D, spawn_pos: Vector2) -> void:
	for child in get_children():
		child.queue_free()
	for entity in EntitiesContainer.instance.get_children():
		entity.queue_free()
	
	add_child.call_deferred(next_room)
	# Man this code does not fucking work
	if next_room.find_child("spikes").enabled == false:
		Player.instance.position = spawn_pos
		return
		
	next_room.find_child("spikes").enabled = false
	Player.instance.position = spawn_pos
	next_room.find_child("spikes").enabled = true
