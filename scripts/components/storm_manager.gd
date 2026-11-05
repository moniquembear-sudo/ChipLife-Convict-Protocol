extends Node
class_name StormManagerComponent

var entity: CharacterBody2D
var storm_interval: float = 30.0
var storm_damage: float = 10.0
var storm_timer: float = 0.0
var in_storm: bool = false
var in_shelter: bool = false
var shelter: Area2D

func setup(parent: CharacterBody2D) -> void:
	entity = parent
	storm_timer = storm_interval

func _physics_process(delta: float) -> void:
	# Comprobar refugio por distancia
	if shelter:
		in_shelter = entity.global_position.distance_to(shelter.global_position) < 60.0
	else:
		in_shelter = false
	
	# Tormenta
	if in_storm:
		if not in_shelter:
			entity.current_health -= storm_damage * delta
			if entity.current_health <= 0:
				entity.queue_free()
	else:
		storm_timer -= delta
		if storm_timer <= 0:
			in_storm = true
			storm_timer = storm_interval
			print("¡Tormenta!")
			await get_tree().create_timer(10.0).timeout
			in_storm = false
			print("La tormenta ha pasado.")
