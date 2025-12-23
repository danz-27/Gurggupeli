extends Camera2D
class_name Camera

static var instance: Camera

var scale_width : int = ProjectSettings.get_setting("display/window/size/viewport_width") / 320
var scale_height : int = ProjectSettings.get_setting("display/window/size/viewport_height") / 180
var camera_offset: Vector2 = Vector2(0.0, -20.0)

func _ready() -> void:
	instance = self
	set_zoom(Vector2(scale_width,scale_height))
	#position = camera_offset
