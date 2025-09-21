extends Node2D

const HEART_AMOUNT := 5

var entity_health_node : EntityHealth
var previous_health : int
@onready var health_icons : Array[Sprite2D] = [$HealthIcon1, $HealthIcon2, $HealthIcon3, $HealthIcon4, $HealthIcon5]


func _ready() -> void:
	await get_tree().physics_frame
	entity_health_node = Player.instance.get_node("EntityHealth")


func _physics_process(_delta: float) -> void:
	var health : int = entity_health_node.health
	if previous_health == health:
		return
	
	var color1 : Color
	var color2 : Color
	
	if health <= 5:
		color1 = Color.DARK_GREEN
		color2 = Color.DARK_GREEN
	elif health <= 10:
		color1 = Color.DARK_GREEN
		color2 = Color.CRIMSON
	else:
		color1 = Color.CRIMSON
		color2 = Color.YELLOW
	
	for i : int in range(HEART_AMOUNT):
		var icon := health_icons[i]

		if (health - 1) % HEART_AMOUNT + 1 <= i:
			icon.modulate = color1
		else:
			icon.modulate = color2
	
	if health < HEART_AMOUNT:
		if health <= 0:
			queue_free()
		else:
			for i : int in range(HEART_AMOUNT - health):
				var icon_position : Vector2 = health_icons[i].position
				var tween : Tween = create_tween()
				tween.tween_property(health_icons[i], "position", Vector2(icon_position.x, 200), 0.5).set_ease(Tween.EASE_IN)
	
	previous_health = health
