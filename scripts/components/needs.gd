extends Node
class_name NeedsComponent

var entity: Entity
var max_hunger: float = 100.0
var current_hunger: float = 100.0
var hunger_decay_rate: float = 2.0
var hunger_threshold: int = 30
var max_health: float = 100.0
var current_health: float = 100.0

func setup(parent: Entity) -> void:
	entity = parent
	current_hunger = max_hunger
	current_health = max_health

func _physics_process(delta: float) -> void:
	current_hunger -= hunger_decay_rate * delta
	current_hunger = clamp(current_hunger, 0, max_hunger)
	if current_hunger <= 0:
		print("Entidad muerta de hambre.")
		entity.queue_free()
	# EL DAÑO CLIMÁTICO AHORA LO GESTIONA storm_manager.gd
