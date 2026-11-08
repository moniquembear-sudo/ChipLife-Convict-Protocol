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
  # NUEVO: Daño por tormenta solar (radiación)
	if WeatherManager.is_solar_flare_active:
		# Si no está en un refugio (comprobamos la distancia al refugio)
		var shelter = get_tree().get_first_node_in_group("refugio")
		var in_shelter = false
		if shelter:
			in_shelter = entity.global_position.distance_to(shelter.global_position) < 100.0
		
		if not in_shelter:
			current_health -= 15.0 * delta # Más daño que la tormenta normal
			if current_health <= 0:
				entity.queue_free()
				print("Entidad muerta por radiación solar.")
		else:
			print("estas en el refugio")
