extends Node
class_name StormManagerComponent

var entity: Entity
var storm_damage: float = 10.0
var solar_flare_damage: float = 15.0

func setup(parent: Entity) -> void:
	entity = parent
	WeatherManager.storm_started.connect(_on_storm_started)
	WeatherManager.storm_ended.connect(_on_storm_ended)

func _physics_process(delta: float) -> void:
	# Si está en el refugio, no recibe daño
	if entity.in_shelter: 
		return
	
	# Daño por tormenta normal
	if WeatherManager.is_storm_active:
		entity.needs.current_health -= storm_damage * delta
		if entity.needs.current_health <= 0:
			print("Entidad muerta por tormenta.")
			entity.queue_free()
	
	# Daño por tormenta solar (radiación)
	if WeatherManager.is_solar_flare_active:
		entity.needs.current_health -= solar_flare_damage * delta
		if entity.needs.current_health <= 0:
			print("Entidad muerta por radiación solar.")
			entity.queue_free()

func _on_storm_started() -> void:
	print("Entidad detecta: Tormenta normal.")

func _on_storm_ended() -> void:
	print("Entidad detecta: Tormenta terminada.")
