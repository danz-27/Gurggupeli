extends Camera2D

var scale_width : int = ProjectSettings.get_setting("display/window/size/viewport_width") / 320
var scale_height : int = ProjectSettings.get_setting("display/window/size/viewport_height") / 180

func _ready() -> void:
	set_zoom(Vector2(scale_width,scale_height))
