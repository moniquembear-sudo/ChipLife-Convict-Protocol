extends Node
class_name MoraleComponent

var entity: Entity
var max_morale: float = 100.0
var current_morale: float = 100.0
var morale_decay: float = 1.0 # Baja 1 por segundo (es un ejemplo, ajustaremos)
var is_rebelling: bool = false

func setup(parent: Entity) -> void:
	entity = parent
	current_morale = max_morale

func _physics_process(delta: float) -> void:
	if is_rebelling: return # Si ya se rebeló, no procesar más
	
	# Factores que bajan la moral
	var decay_multiplier = 1.0
	
	# Si tiene hambre extrema, la moral baja más rápido
	if entity.needs and entity.needs.current_hunger < 20.0:
		decay_multiplier += 1.0
	
	# Si está herido (salud baja), la moral baja más rápido
	if entity.needs and entity.needs.current_health < 50.0:
		decay_multiplier += 1.0
	
	current_morale -= morale_decay * decay_multiplier * delta
	current_morale = clamp(current_morale, 0, max_morale)
	
	# Si la moral llega a 0, se rebela
	if current_morale <= 0:
		_start_rebellion()

func _start_rebellion() -> void:
	is_rebelling = true
	print("¡MOTÍN! El prisionero ha perdido el control.")
	# Quitar prioridades y poner "rebelde" al cerebro (lo haremos en el brain)
	if entity.brain:
		var rebel_priority: Array[String] = ["rebelde"]
		entity.brain.set_priorities(rebel_priority)
