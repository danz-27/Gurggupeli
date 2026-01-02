extends TextureRect

func _physics_process(_delta: float) -> void:
	if GlobalVariables.big_rat_killed:
		visible = true
