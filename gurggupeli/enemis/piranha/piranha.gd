extends Entity
class_name Piranha

static func create(pos: Vector2) -> Piranha:
	var piranha : Piranha = preload("res://enemis/piranha/piranha.tscn").instantiate()
	piranha.position = pos
	EntitiesContainer.add(piranha)
	return piranha

var move_speed := 100
var move_counter := 50
func _physics_process(delta: float) -> void:
	
	velocity.x += move_speed

	
	
	
	move_and_slide()
