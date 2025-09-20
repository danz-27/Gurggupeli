extends Entity
class_name Piranha

static func create(pos: Vector2) -> Piranha:
	var piranha : Piranha = preload("res://enemis/piranha.tscn").instantiate()
	piranha.position = pos
	EntitiesContainer.add(piranha)
	return piranha

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
