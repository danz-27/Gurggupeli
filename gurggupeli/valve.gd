extends Node2D

var valve_children : Array = []

func get_all_children(node) -> Array:
	var nodes : Array = []
	for N in node.get_children():
		nodes.append(N)
	return nodes
	
func valve_activated() -> void:
	valve_children = get_all_children(self)
	for n in valve_children:
		if n.has_method("activate"):
			n.activate()
			
func valve_deactivated() -> void:
	valve_children = get_all_children(self)
	for n in valve_children:
		if n.has_method("deactivate"):
			n.deactivate()
	
func _ready() -> void:
	return

func _physics_process(delta: float) -> void:
	return


func _on_area_2d_body_entered(player: Node2D) -> void:
	valve_activated()


func _on_area_2d_body_exited(player: Node2D) -> void:
	valve_deactivated()
