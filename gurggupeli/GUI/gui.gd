extends CanvasLayer
class_name GUI

static var instance : GUI

static func show_death_screen() -> void:
	instance.death_screen.visible = true

@onready var death_screen := $DeathScreen

func _ready() -> void:
	instance = self
	pass
