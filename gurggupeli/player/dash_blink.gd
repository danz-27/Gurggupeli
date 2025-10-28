extends Node2D

@onready var halo_sprite := $Sprite2D
var is_growing := false
var has_already_been_started := false

func start_halo() -> void:
	if not has_already_been_started:
		halo_sprite.modulate.a = 0
		print("reset alpha")
	halo_sprite.visible = true
	has_already_been_started = true
	
func stop_halo() -> void:
	halo_sprite.visible = false
	has_already_been_started = false

func _physics_process(_delta: float) -> void:
	halo_sprite.set_frame(get_parent().get_frame())
	halo_sprite.flip_h = get_parent().is_flipped_h()
	if is_growing:
		halo_sprite.modulate.a += 0.05
		if halo_sprite.modulate.a >= 1:
			is_growing = false
	else:
		halo_sprite.modulate.a -= 0.05
		if halo_sprite.modulate.a <= 0:
			is_growing = true
