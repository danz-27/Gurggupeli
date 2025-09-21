extends Node2D

@onready var background1 = $background1
@onready var background2 = $background2
var speed: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background1.position.x = 0
	background2.position.x = 328


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	background1.position.x -= speed
	background2.position.x -= speed
	if background1.position.x <= -328:
		background1.position.x = abs(background1.position.x)
	if background2.position.x <= -328:
		background2.position.x = abs(background2.position.x)


func _on_play_button_pressed() -> void:
	print("play button pressed!")
	visible = false


func _on_options_button_pressed() -> void:
	print("options button pressed!")


func _on_quit_button_pressed() -> void:
	print("quit button pressed!")
