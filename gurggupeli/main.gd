extends Node
class_name Main

var scale_width : int = ProjectSettings.get_setting("display/window/size/viewport_width") / 320
var scale_height : int = ProjectSettings.get_setting("display/window/size/viewport_height") / 180

static var game_time := 0

func _ready() -> void:
	$GUI.visible = true

func _physics_process(_delta: float) -> void:
	game_time += 1
