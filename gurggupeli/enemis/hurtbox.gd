extends Area2D
class_name HurtBox

@export var damage := 1
@export var hit_cooldown := 1.0
@export var is_damageable: bool = true

@onready var hit_cooldown_timer : Timer = $Cooldown


func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if !hit_cooldown_timer.is_stopped():
		return
	
	var overlapping_areas: Array[Area2D] = get_overlapping_areas()
	
	for area: Area2D in overlapping_areas:
		if area is EntityHealth:
			#var entity_health: EntityHealth = area
			if get_parent() == area.get_parent():
				continue
			if get_parent().team == area.get_parent().team:
				continue
			
			if is_damageable:
				if area.get_parent() is Player:
					if area.get_parent().velocity.y > 0:
						$"../EntityHealth".take_damage(1)
						SoftCollision.velocity_to_add += Vector2.UP * 500
						area.get_parent().health.iframes_timer.start(area.get_parent().health.iframes_duration)
						area.get_parent().reset_dashes()
			
			hit_cooldown_timer.start(hit_cooldown)
			area.take_damage(damage)
			return
