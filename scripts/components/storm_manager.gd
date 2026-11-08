extends Node
class_name StormManagerComponent

var entity: Entity
var storm_damage: float = 10.0
var in_shelter: bool = false

func setup(parent: Entity) -> void:
	entity = parent
	WeatherManager.storm_started.connect(_on_storm_started)
	WeatherManager.storm_ended.connect(_on_storm_ended)

func _physics_process(delta: float) -> void:
	# Comprobar si está en el refugio
	var shelter = get_tree().get_first_node_in_group("refugio")
	if shelter:
		in_shelter = entity.global_position.distance_to(shelter.global_position) < 100.0
	else:
		in_shelter = false
	
	# Daño por tormenta normal
	if WeatherManager.is_storm_active and not in_shelter:
		entity.needs.current_health -= storm_damage * delta
		if entity.needs.current_health <= 0:
			print("Entidad muerta por tormenta.")
			entity.queue_free()

func _on_storm_started() -> void:
	print("Entidad detecta: Tormenta normal.")

func _on_storm_ended() -> void:
	print("Entidad detecta: Tormenta terminada.")
