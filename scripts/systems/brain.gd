extends Node
class_name Brain

var entity: CharacterBody2D
var priorities: Array[String] = ["refugiarse", "comer", "transportar", "recolectar", "descansar"]

var storage: Area2D
var shelter: Area2D

func setup(parent: CharacterBody2D) -> void:
	entity = parent

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
				return true
		"transportar":
			if not entity.carrying_rock:
				return false
			if storage:
				entity.movement.move_to(storage.global_position)
				return true
		"comer":
			if entity.needs.current_hunger >= entity.needs.hunger_threshold:
				return false
			var food = _find_nearest_food()
			if food:
				entity.movement.move_to(food.global_position)
				return true
		"refugiarse":
			if not entity.storm_manager.in_storm:
				return false
			if shelter:
				var dist = entity.global_position.distance_to(shelter.global_position)
				if dist < 60.0:
					entity.movement.stop()
					return true
				else:
					entity.movement.move_to(shelter.global_position)
					return true
			return false
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
