extends Node2D

const HEART_AMOUNT := 5

var entity_health_node : EntityHealth
var previous_health : int
@onready var health_icons : Array[Sprite2D]
var health_icon_positions : Array[Vector2]
var tween_dict : Dictionary

func _ready() -> void:
	health_icons.append_array(get_children().filter(func(icon: Sprite2D) -> bool: return icon.z_index == 0))
	health_icon_positions.assign(health_icons.map(func(icon: Sprite2D) -> Vector2: return icon.position))
	await get_tree().physics_frame
	entity_health_node = Player.instance.get_node("EntityHealth")
	


func _physics_process(_delta: float) -> void:
	var health : int = entity_health_node.health
	if previous_health == health:
		return
	# Gain hp
	if previous_health < health and previous_health < HEART_AMOUNT:
		for i : int in range(len(health_icons)):
			# selvitä huomen mitä tää meinaa
			
			if (previous_health <= i) and (i < health):
				# Check if tween animation is still running and if it is, kill it
				if tween_dict.has(health_icons[i]) and tween_dict[health_icons[i]].is_running():
					tween_dict[health_icons[i]].kill()
				
				health_icons[i].position = health_icon_positions[i]
	
	
	var color1 : Color
	var color2 : Color 
	if health <= 5:
		color1 = Color("68f300")
		color2 = Color("68f300")
	elif health <= 10:
		color1 = Color("68f300")
		color2 = Color("ffdf00")
	else:
		color1 = Color("ffdf00")
		color2 = Color(1.0, 0.639, 0.0, 1.0)
	
	for i : int in range(HEART_AMOUNT):
		var icon := health_icons[i]

		if (health - 1) % HEART_AMOUNT + 1 <= i:
			icon.modulate = color1
		else:
			icon.modulate = color2
	
	if previous_health > health and health < HEART_AMOUNT:
		for i in range(previous_health - clampi(health, 0, 5)):
			var icon_position : Vector2 = health_icons[clampi(health + i, 0, 4)].position
			var tween : Tween = create_tween()
			
			# Kill extra tweens
			if tween_dict.has(health_icons[clampi(health + i, 0, 4)]):
				tween_dict[health_icons[clampi(health + i, 0, 4)]].kill()
			
			tween.tween_property(health_icons[clampi(health + i, 0, 4)], "position", Vector2(icon_position.x, 300), 3).set_ease(Tween.EASE_IN)
			tween_dict[health_icons[clampi(health + i, 0, 4)]] = tween
	
	previous_health = health
