extends StaticBody2D

func _physics_process(_delta: float) -> void:
	$CollisionShape2D.disabled = GlobalVariables.has_dash
