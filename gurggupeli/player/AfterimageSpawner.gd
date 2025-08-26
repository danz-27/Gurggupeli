extends Node2D

var spawning: bool = false
var timer: float = 0.0
var time_between_spawns: float = 0.075

func start_spawning() -> void:
	spawning = true
	timer = 0.0

func stop_spawning() -> void:
	spawning = false
	timer = 0.0

func make_afterimage() -> void:
	var scene_instance: Node = preload("res://player/afterimage.tscn").instantiate()
	scene_instance.flip_h = get_parent().gurggu.flip_h
	get_tree().current_scene.add_child(scene_instance)
	scene_instance.global_position = get_parent().global_position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawning:
		timer += delta
		if timer > time_between_spawns:
			timer = 0.0
			make_afterimage()
