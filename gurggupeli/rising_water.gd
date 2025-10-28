extends Node2D

@export var rise_level_in_tiles: int
@export var rise_speed_in_px_per_frame: float
@onready var water := $water

var activated := false
var saved_rise_level := 0.0 #tallennetaan kasvu koska water.position.y ottaa vaan kokonaislukuja
var rounded_rise := 0

func _ready() -> void:
	rise_level_in_tiles = rise_level_in_tiles * 8 #muutetaan rise_level_in_tiles tarkoittamaan tileja pixelien sijaan
	rise_speed_in_px_per_frame = -rise_speed_in_px_per_frame #flipataan rise_speed_in_px_per_frame, sillä -y on ylöspäin

func _activate() -> void:
	activated = true
	
func _deactivate() -> void:
	activated = false
	
func _physics_process(_delta: float) -> void:
	if activated:
		if water.position.y > -rise_level_in_tiles:
			saved_rise_level += rise_speed_in_px_per_frame
			if saved_rise_level <= 1:
				rounded_rise = floor(saved_rise_level)
				water.position.y += rounded_rise
				saved_rise_level -= rounded_rise
	else:
		if water.position.y != 0:
			saved_rise_level -= rise_speed_in_px_per_frame
			if saved_rise_level >= 1:
				rounded_rise = floor(saved_rise_level)
				water.position.y += rounded_rise
				saved_rise_level -= rounded_rise
