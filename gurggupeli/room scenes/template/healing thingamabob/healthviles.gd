extends Control

@export var full_vile_texture: Texture2D
@export var empty_vile_texture: Texture2D
var vile_amount: int = 3
var viles_full: int = 0
var max_viles: int = 5

func _ready() -> void:
	for vile in $VBoxContainer.get_children():
		vile.visible = false
	for vile in vile_amount:
		$VBoxContainer.get_children()[vile].visible = true

func _add_vile() -> void:
	if vile_amount < max_viles:
		vile_amount += 1
		for vile in $VBoxContainer.get_children():
			vile.visible = false
		for vile in vile_amount:
			$VBoxContainer.get_children()[vile].visible = true
		
func fill_vile() -> void:
	if viles_full < vile_amount:
		viles_full += 1
		for vile: TextureRect in $VBoxContainer.get_children():
			if vile.texture == empty_vile_texture:
				vile.texture = full_vile_texture
				break
		
func heal() -> void:
	viles_full -= 1
	Player.instance.health.health += 3
	$VBoxContainer.get_children()[viles_full].texture = empty_vile_texture

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("heal") and viles_full > 0:
		heal()
