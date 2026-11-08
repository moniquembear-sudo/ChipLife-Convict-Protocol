extends Node

signal time_changed(hour: int, minute: int)
signal day_night_changed(is_day: bool)

# Configuración de tiempo
var day_duration_seconds: float = 120.0 # Un día completo dura 2 minutos reales
var time_scale: float = 1.0

# Estado actual
var current_time_seconds: float = 0.0
var current_day: int = 1
var current_hour: int = 6 # Empezamos a las 6:00 AM
var current_minute: int = 0
var is_day: bool = true

func _process(delta: float) -> void:
	# Avanzar el tiempo
	current_time_seconds += delta * time_scale
	
	# Calcular la hora actual (0 a 24)
	# 120 segundos = 24 horas. Entonces 5 segundos = 1 hora.
	var total_hours = (current_time_seconds / day_duration_seconds) * 24.0
	current_hour = int(total_hours) % 24
	current_minute = int((total_hours - int(total_hours)) * 60)
	
	# Detectar cambio de día
	if current_time_seconds >= day_duration_seconds:
		current_time_seconds = 0.0
		current_day += 1
	
	# Detectar Día/Noche (de 6:00 a 18:00 es de día)
	var new_is_day = (current_hour >= 6 and current_hour < 18)
	if new_is_day != is_day:
		is_day = new_is_day
		day_night_changed.emit(is_day)
		print("Cambio de ciclo: ", "Día" if is_day else "Noche")
		
	# Emitir señal cada minuto de juego
	time_changed.emit(current_hour, current_minute)

func get_time_string() -> String:
	return "Día %d - %02d:%02d" % [current_day, current_hour, current_minute]
