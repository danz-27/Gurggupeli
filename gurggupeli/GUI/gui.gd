extends CanvasLayer
class_name GUI

var scaleWidth = ProjectSettings.get_setting("display/window/size/viewport_width")/320
var scaleHeight = ProjectSettings.get_setting("display/window/size/viewport_height")/180

static var instance : GUI

static func show_death_screen() -> void:
	instance.death_screen.visible = true

@onready var death_screen := $DeathScreen

func _ready() -> void:
	instance = self
	set_scale(Vector2(scaleWidth, scaleHeight))
	pass
