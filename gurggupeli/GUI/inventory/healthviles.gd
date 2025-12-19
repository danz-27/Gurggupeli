extends Control

@export var full_vile_texture: Texture2D
@export var empty_vile_texture: Texture2D
@onready var healthviles: VBoxContainer = $"Health viles"
@onready var crowbar: TextureRect = $items/rautasorkka
@onready var max_viles: int = $"Health viles".get_children().size()
var vile_amount: int = 0
var viles_full: int = 0

func _ready() -> void:
	crowbar.visible = GlobalVariables.has_crowbar
	for vile in healthviles.get_children():
		vile.visible = false
	for vile in vile_amount:
		healthviles.get_children()[vile].visible = true

func _add_vile() -> void:
	if vile_amount < max_viles:
		vile_amount += 1
		for vile in healthviles.get_children():
			vile.visible = false
		for vile in vile_amount:
			healthviles.get_children()[vile].visible = true
		
func fill_vile() -> void:
	if viles_full < vile_amount:
		viles_full += 1
		for vile: TextureRect in healthviles.get_children():
			if vile.texture == empty_vile_texture:
				vile.texture = full_vile_texture
				break
		
func heal() -> void:
	viles_full -= 1
	Player.instance.health.health += 3
	healthviles.get_children()[viles_full].texture = empty_vile_texture

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("heal") and viles_full > 0:
		heal()
	crowbar.visible = GlobalVariables.has_crowbar
