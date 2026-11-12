extends Node
class_name Brain

var entity: Entity
# Prioridades por defecto:
var priorities: Array[String] = ["refugiarse", "comer", "recargar", "transportar", "descansar"]

func setup(parent: Entity) -> void:
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
			if entity.carrying_rock: return false
			var rock = _find_nearest_rock()
			if rock:
				entity.movement.move_to(rock.global_position)
				if entity.global_position.distance_to(rock.global_position) < 15.0:
					entity.carrying_rock = true
					rock.queue_free()
					print("Roca recolectada")
				return true
		"minar":
			if entity.carrying_rock: return false
			var metal = _find_nearest_metal()
			if metal:
				entity.movement.move_to(metal.global_position)
				if entity.global_position.distance_to(metal.global_position) < 15.0:
					metal.queue_free()
					InventoryManager.add_metal(1) # <-- VA DIRECTO AL INVENTARIO GLOBAL
					print("Metal minado y guardado en inventario")
				return true
		"transportar":
			if not entity.carrying_rock: return false
			var storage = get_tree().get_first_node_in_group("almacen")
			if storage:
				entity.movement.move_to(storage.global_position)
				if entity.global_position.distance_to(storage.global_position) < 40.0:
					entity.carrying_rock = false
					if storage.has_method("store_rock"): 
						storage.store_rock()
						InventoryManager.add_rock(1) # <-- SUMA AL INVENTARIO GLOBAL
					print("Roca depositada")
				return true
		"comer":
			if not entity.needs: return false
			if entity.needs.current_hunger >= entity.needs.hunger_threshold: return false
			var food = _find_nearest_food()
			if food:
				entity.movement.move_to(food.global_position)
				if entity.global_position.distance_to(food.global_position) < 15.0:
					entity.needs.current_hunger = entity.needs.max_hunger
					food.queue_free()
					print("Comida consumida")
				return true
		"recargar":
			if not entity.energy: return false
			if entity.energy.current_energy >= (entity.energy.max_energy * 0.9): return false
			var station = get_tree().get_first_node_in_group("estacion_solar")
			if station:
				entity.movement.move_to(station.global_position)
				if entity.global_position.distance_to(station.global_position) < 40.0:
					entity.energy.current_energy = entity.energy.max_energy
					print("Droide recargado")
				return true
		"refugiarse":
			if not entity.storm_manager: return false
			# Si hay tormenta o tormenta solar, y no está en refugio
			if not (WeatherManager.is_storm_active or WeatherManager.is_solar_flare_active): return false
			
			# Si YA está en el refugio (por colisión), comprobamos si está en el centro
			if entity.in_shelter:
				var shelter = get_tree().get_first_node_in_group("refugio")
				if shelter:
					var dist_al_centro = entity.global_position.distance_to(shelter.global_position)
					if dist_al_centro < 30.0:
						# Ya está en el centro, puede dejar de moverse
						entity.movement.stop()
						return true
					else:
						# Está en el borde, debe seguir caminando al centro
						entity.movement.move_to(shelter.global_position)
						return true
			else:
				# No ha tocado el refugio aún, moverse hacia él
				var shelter = get_tree().get_first_node_in_group("refugio")
				if shelter:
					entity.movement.move_to(shelter.global_position)
					return true
		"descansar":
			entity.movement.stop()
			return true
		"defender":
			if not entity.combat: return false
			var creature = _find_nearest_creature()
			if creature:
				entity.movement.move_to(creature.global_position)
				if entity.global_position.distance_to(creature.global_position) < 40.0:
					entity.movement.stop()
					entity.combat.attack(creature)
				return true
		"rebelde":
			# El prisionero rebelde busca la criatura más cercana o ataca a otra entidad
			var target = _find_nearest_entity()
			if target:
				entity.movement.move_to(target.global_position)
				if entity.global_position.distance_to(target.global_position) < 40.0:
					entity.movement.stop()
					if entity.combat:
						entity.combat.attack(target)
			return true
		"comerciar":
			var ship = get_tree().get_first_node_in_group("merchant_ship")
			if ship and ship.is_present:
				entity.movement.move_to(ship.global_position)
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

func _find_nearest_metal() -> Area2D:
	var nearest: Area2D = null
	var min_dist = INF
	for m in get_tree().get_nodes_in_group("metal"):
		var d = entity.global_position.distance_to(m.global_position)
		if d < min_dist:
			min_dist = d
			nearest = m
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

func _find_nearest_entity() -> Node2D:
	var nearest = null
	var min_dist = INF
	for e in get_tree().get_nodes_in_group("entities"):
		if e == entity: continue # No se ataca a sí mismo
		var d = entity.global_position.distance_to(e.global_position)
		if d < min_dist:
			min_dist = d
			nearest = e
	return nearest

func _find_nearest_creature() -> Node2D:
	var nearest = null
	var min_dist = INF
	for c in get_tree().get_nodes_in_group("creatures"):
		var d = entity.global_position.distance_to(c.global_position)
		if d < min_dist:
			min_dist = d
			nearest = c
	# Añadir rivales al objetivo
	for e in get_tree().get_nodes_in_group("entities"):
		if e == entity: continue
		# Si la entidad tiene RivalAI, es un enemigo
		if e.has_node("RivalAI"):
			var d = entity.global_position.distance_to(e.global_position)
			if d < min_dist:
				min_dist = d
				nearest = e
	return nearest
