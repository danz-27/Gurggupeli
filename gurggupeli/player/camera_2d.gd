extends Camera2D

var scaleWidth = ProjectSettings.get_setting("display/window/size/viewport_width")/320
var scaleHeight = ProjectSettings.get_setting("display/window/size/viewport_height")/180

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_zoom(Vector2(scaleWidth,scaleHeight))
	pass # Replace with function body.
