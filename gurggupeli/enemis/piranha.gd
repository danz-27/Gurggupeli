extends Entity
class_name Piranha

static func create(pos: Vector2) -> Piranha:
	var piranha : Piranha = preload("res://enemis/piranha.tscn").instantiate()
	piranha.position = pos
	EntitiesContainer.add(piranha)
	return piranha
