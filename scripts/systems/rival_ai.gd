extends Node
class_name RivalAI

var entity: Entity
var target = null

func setup(parent: Entity) -> void:
	entity = parent

func _physics_process(_delta: float) -> void:
	# Si no tiene objetivo o el objetivo ya no existe, buscar uno nuevo
	if not is_instance_valid(target):
		target = _find_target()
	
	if target:
		var dist = entity.global_position.distance_to(target.global_position)
		if dist > 15.0:
			entity.movement.move_to(target.global_position)
		else:
			# Recolectar
			print("Rival recolecta recurso.")
			target.queue_free()
			InventoryManager.rocks += 1 # Suma a su inventario (o al global, para hacerlo fácil)
			target = null

func _find_target() -> Node2D:
	var nearest = null
	var min_dist = INF
	# Los rivales buscan rocas y metales
	for r in get_tree().get_nodes_in_group("roca"):
		var d = entity.global_position.distance_to(r.global_position)
		if d < min_dist:
			min_dist = d
			nearest = r
	for m in get_tree().get_nodes_in_group("metal"):
		var d = entity.global_position.distance_to(m.global_position)
		if d < min_dist:
			min_dist = d
			nearest = m
	return nearest
