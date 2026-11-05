extends Node
class_name Brain

var entity: Entity
var priorities: Array[String] = ["refugiarse", "comer", "recolectar", "transportar", "descansar"]

func setup(parent: Entity) -> void:
	entity = parent

# ESTA ES LA FUNCIÓN QUE FALTABA:
func set_priorities(new_priorities: Array[String]) -> void:
	priorities = new_priorities

func execute() -> void:
	for action in priorities:
		if _try_action(action):
			return

func _try_action(action: String) -> bool:
	match action:
		"recolectar":
			if entity.carrying_rock:
				return false
			var rock = _find_nearest_rock()
			if rock:
				entity.movement.move_to(rock.global_position)
				if entity.global_position.distance_to(rock.global_position) < 15.0:
					entity.carrying_rock = true
					rock.queue_free()
					print("Roca recolectada")
				return true
		"transportar":
			if not entity.carrying_rock:
				return false
			var storage = get_tree().get_first_node_in_group("almacen")
			if storage:
				entity.movement.move_to(storage.global_position)
				if entity.global_position.distance_to(storage.global_position) < 40.0:
					entity.carrying_rock = false
					if storage.has_method("store_rock"):
						storage.store_rock()
					print("Roca depositada")
				return true
		"comer":
			if entity.needs.current_hunger >= entity.needs.hunger_threshold:
				return false
			var food = _find_nearest_food()
			if food:
				entity.movement.move_to(food.global_position)
				if entity.global_position.distance_to(food.global_position) < 15.0:
					entity.needs.current_hunger = entity.needs.max_hunger
					food.queue_free()
					print("Comida consumida")
				return true
		"refugiarse":
			if not entity.storm_manager.in_storm or entity.storm_manager.in_shelter:
				return false
			var shelter = get_tree().get_first_node_in_group("refugio")
			if shelter:
				entity.movement.move_to(shelter.global_position)
				return true
		"descansar":
			entity.movement.stop()
			return true
	return false

func _find_nearest_rock() -> Area2D:
	var nearest: Area2D = null
	var min_dist = INF
	for rock in get_tree().get_nodes_in_group("roca"):
		var d = entity.global_position.distance_to(rock.global_position)
		if d < min_dist:
			min_dist = d
			nearest = rock
	return nearest

func _find_nearest_food() -> Area2D:
	var nearest: Area2D = null
	var min_dist = INF
	for food in get_tree().get_nodes_in_group("comida"):
		var d = entity.global_position.distance_to(food.global_position)
		if d < min_dist:
			min_dist = d
			nearest = food
	return nearest
