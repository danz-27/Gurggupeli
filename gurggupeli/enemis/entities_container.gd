extends Node2D
class_name EntitiesContainer

static var instance: EntitiesContainer

static func add(entity: Entity) -> void:
	instance.add_child(entity)


func _ready() -> void:
	instance = self
