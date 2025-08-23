extends Sprite2D

var player: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation = player.velocity.angle()
	scale.x = player.velocity.length() * 0.01
	scale.y = (-1 if player.velocity.x < 0 else 1)
