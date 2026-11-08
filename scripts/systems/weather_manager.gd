extends Node

signal storm_started
signal storm_ended
signal solar_flare_started
signal solar_flare_ended

var is_storm_active: bool = false
var is_solar_flare_active: bool = false

var weather_timer: float = 30.0 # Cada 30 segundos pasa algo
var current_event: String = ""

func _process(delta: float) -> void:
	weather_timer -= delta
	if weather_timer <= 0:
		_trigger_random_event()

func _trigger_random_event() -> void:
	# Elegir aleatoriamente entre tormenta, tormenta solar o calma
	var rng = randi() % 3
	
	if rng == 0 and not is_storm_active and not is_solar_flare_active:
		_start_storm()
	elif rng == 1 and not is_storm_active and not is_solar_flare_active:
		_start_solar_flare()
	else:
		# Calma, vuelve a intentarlo en 10 segundos
		weather_timer = 10.0

func _start_storm() -> void:
	is_storm_active = true
	print("¡TORMENTA INICIADA!")
	storm_started.emit()
	await get_tree().create_timer(15.0).timeout
	is_storm_active = false
	storm_ended.emit()
	print("La tormenta ha pasado.")
	weather_timer = 30.0

func _start_solar_flare() -> void:
	is_solar_flare_active = true
	print("¡TORMENTA SOLAR INICIADA!")
	solar_flare_started.emit()
	await get_tree().create_timer(15.0).timeout
	is_solar_flare_active = false
	solar_flare_ended.emit()
	print("La tormenta solar ha pasado.")
	weather_timer = 30.0