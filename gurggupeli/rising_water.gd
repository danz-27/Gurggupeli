extends Node2D

@export var rise_level: int
@export var rise_speed: float
@onready var water := $water

var activated := true
var saved_rise_level := 0.0 #tallennetaan kasvu koska water.position.y ottaa vaan kokonaislukuja
var rounded_rise := 0

func activate() -> void:
	activated = true
	
func deactivate() -> void:
	activated = false
	
func _physics_process(delta: float) -> void:
	if activated:
		if water.position.y > -rise_level:
			saved_rise_level += -rise_speed/100
			print(saved_rise_level)
			if saved_rise_level <= 1:
				rounded_rise = floor(saved_rise_level)
				water.position.y += rounded_rise
				saved_rise_level -= rounded_rise
		else:
			activated = false
	else:
		if water.position.y != 0:
			saved_rise_level -= -rise_speed/100
			if saved_rise_level >= 1:
				rounded_rise = floor(saved_rise_level)
				water.position.y += rounded_rise
				saved_rise_level -= rounded_rise
		else:
			activated = true
