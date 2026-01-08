extends Control

func _ready() -> void:
	$VBoxContainer/Dash.connect("pressed", _enable_dash)
	$VBoxContainer/Crowbar.connect("pressed", _enable_crowbar)
	$VBoxContainer/Back.connect("pressed", _back)



func _enable_dash() -> void:
	GlobalVariables.has_dash = true if GlobalVariables.has_dash == false else false

func _enable_crowbar() -> void:
	GlobalVariables.has_crowbar = true if GlobalVariables.has_crowbar == false else false

func _back() -> void:
	hide()
	for child in $"../OptionsMenu".get_children():
		child.show()
