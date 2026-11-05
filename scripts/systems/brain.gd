extends Node
class_name Brain

var prisoner: CharacterBody2D
var priorities: Array[String] = ["refugiarse", "comer", "transportar", "recolectar", "descansar"]

var rock_detector: Area2D
var storage: Area2D
var food_list: Array[Area2D] = []
var shelter: Area2D

func set_priorities(new_priorities: Array[String]) -> void:
	priorities = new_priorities

func execute() -> void:
	for action in priorities:
		if _try_action(action):
			return

func _try_action(action: String) -> bool:
	match action:
		"recolectar":
			if prisoner.carrying_rock:
				return false
			var rock = _find_nearest_rock()
			if rock:
				prisoner.target_position = rock.global_position
				prisoner.moving = true
				return true
		"transportar":
			if not prisoner.carrying_rock:
				return false
			if storage:
				prisoner.target_position = storage.global_position
				prisoner.moving = true
				return true
		"comer":
			if prisoner.current_hunger >= prisoner.hunger_threshold:  # <-- CAMBIO AQUÍ
				return false
			var food = _find_nearest_food()
			if food:
				prisoner.target_position = food.global_position
				prisoner.moving = true
				return true
		"refugiarse":
			if not prisoner.in_storm:
				return false
			# Comprobar distancia directamente (independiente de in_shelter)
			if shelter:
				var dist = prisoner.global_position.distance_to(shelter.global_position)
				if dist < 60.0:
					# Ya está en el refugio: no moverse
					prisoner.moving = false
					return true  # Acción completada (ya refugiado)
				else:
					prisoner.target_position = shelter.global_position
					prisoner.moving = true
					return true
			return false
		"descansar":
			prisoner.moving = false
			return true
	return false

func _find_nearest_rock() -> Area2D:
	var nearest: Area2D = null
	var min_dist = INF
	for rock in get_tree().get_nodes_in_group("roca"):
		var d = prisoner.global_position.distance_to(rock.global_position)
		if d < min_dist:
			min_dist = d
			nearest = rock
	return nearest

func _find_nearest_food() -> Area2D:
	var nearest: Area2D = null
	var min_dist = INF
	for food in get_tree().get_nodes_in_group("comida"):
		var d = prisoner.global_position.distance_to(food.global_position)
		if d < min_dist:
			min_dist = d
			nearest = food
	return nearest
	
