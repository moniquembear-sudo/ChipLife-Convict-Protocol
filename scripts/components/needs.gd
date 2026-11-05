extends Node
class_name NeedsComponent

var entity: CharacterBody2D
var max_hunger: float = 100.0
var hunger_decay_rate: float = 2.0
var current_hunger: float = 100.0
var max_health: float = 100.0
var current_health: float = 100.0
var hunger_threshold: int = 30

func setup(parent: CharacterBody2D) -> void:
	entity = parent
	max_hunger = parent.max_hunger if "max_hunger" in parent else 100.0
	hunger_decay_rate = parent.hunger_decay_rate if "hunger_decay_rate" in parent else 2.0
	max_health = parent.max_health if "max_health" in parent else 100.0
	current_hunger = max_hunger
	current_health = max_health

func _physics_process(delta: float) -> void:
	current_hunger -= hunger_decay_rate * delta
	current_hunger = clamp(current_hunger, 0, max_hunger)
	if current_hunger <= 0:
		current_health -= 5.0 * delta
		current_health = clamp(current_health, 0, max_health)
		if current_health <= 0:
			entity.queue_free()
			print("Entidad muerta de hambre.")
