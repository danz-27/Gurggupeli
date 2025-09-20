extends Area2D
class_name HurtBox

@export var damage := 1
@export var hit_cooldown := 1.0

@onready var hit_cooldown_timer : Timer = $Cooldown


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if !hit_cooldown_timer.is_stopped():
		return
	
	var overlapping_areas : Array[Area2D] = get_overlapping_areas()
	for area : Area2D in overlapping_areas:
		if area is EntityHealth:
			var entity_health: EntityHealth = area
			if get_parent() == entity_health.get_parent():
				continue
			
			hit_cooldown_timer.start(hit_cooldown)
			entity_health.take_damage(damage)
			return
