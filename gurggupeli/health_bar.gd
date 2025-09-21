extends Node2D

var entity_health_node : EntityHealth
@onready var health_icons : Array[Sprite2D] = [$HealthIcon1, $HealthIcon2, $HealthIcon3, $HealthIcon4, $HealthIcon5]
var tween : Tween = create_tween()

func _ready() -> void:
	await get_tree().physics_frame
	entity_health_node = Player.instance.get_node("EntityHealth")


#func _physics_process(delta: float) -> void:
	#var health := entity_health_node.health % 5
	#if health < 5:
		#for i : int in range(5-health):
			#tween.tween_property(health_icons[i], "transform", Vector2(0, -300), 0.6)
			#await get_tree().physics_frame
