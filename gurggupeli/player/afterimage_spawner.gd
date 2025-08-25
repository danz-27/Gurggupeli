extends Node2D

@export var afterimage_scene: PackedScene = preload("res://player/afterimage.tscn")
@export var spawn_interval: float = 0.05

var spawn_timer: float = 0.0
var spawning: bool = false

func start_spawning() -> void:
	spawning = true
	spawn_timer = 0.0

func stop_spawning() -> void:
	spawning = false

func _process(delta: float) -> void:
	if spawning:
		spawn_timer -= delta
		if spawn_timer <= 0.0:
			spawn_timer = spawn_interval
			var afterimage: Sprite2D = afterimage_scene.instantiate()
			afterimage.global_position = get_parent().global_position
			afterimage.flip_h = get_parent().gurggu.flip_h
			get_tree().current_scene.add_child(afterimage)
