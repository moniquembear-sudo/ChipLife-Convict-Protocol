extends CharacterBody2D

@export var speed: float = 200.0
@export var max_hunger: float = 100.0
@export var hunger_decay_rate: float = 2.0  # puntos por segundo
@export var max_health: float = 100.0

@onready var rock_detector: Area2D = $RockDetector
@onready var brain: Node = $Brain

var target_position: Vector2 = Vector2.ZERO
var moving: bool = false
var carrying_rock: bool = false
var current_hunger: float = 100.0
var current_health: float = 100.0
var hunger_threshold: int = 30  # <-- NUEVO: Umbral de hambre por defecto


@export var storm_interval: float = 10.0  # segundos entre tormentas
@export var storm_damage: float = 10.0    # daño por segundo durante tormenta

var storm_timer: float = 0.0
var in_storm: bool = false
var in_shelter: bool = false

func _ready() -> void:
	storm_timer = storm_interval
	if rock_detector:
		rock_detector.area_entered.connect(_on_area_detected)
		# NO conectamos area_exited para el refugio
	current_hunger = max_hunger
	current_health = max_health
	add_to_group("prisionero")
	brain.prisoner = self
	await get_tree().process_frame
	
	# Buscar el panel de programación en la escena
	var work_panel = get_tree().get_first_node_in_group("work_panel")
	if work_panel:
		brain.set_priorities(work_panel.get_current_priorities())
	else:
		print("ADVERTENCIA: No se encontró el panel de programación.")
	
	brain.storage = get_tree().get_first_node_in_group("almacen")
	brain.shelter = get_tree().get_first_node_in_group("refugio")
	if not brain.storage:
		print("ADVERTENCIA: No se encontró almacén en el grupo 'almacen'")
	if not brain.shelter:
		print("ADVERTENCIA: No se encontró refugio")
	else:
		print("Refugio encontrado en: ", brain.shelter.global_position)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		target_position = get_global_mouse_position()
		moving = true
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		target_position = get_global_mouse_position()
		moving = true

func _physics_process(delta: float) -> void:
	# Hambre
	current_hunger -= hunger_decay_rate * delta
	if current_hunger <= 0:
		current_hunger = 0
		current_health -= 5.0 * delta
		if current_health <= 0:
			current_health = 0
			print("El prisionero ha muerto de hambre.")
			queue_free()
	else:
		current_hunger = min(current_hunger, max_hunger)

	# Comprobar si está cerca del refugio (solo por distancia)
	if brain.shelter:
		var dist = global_position.distance_to(brain.shelter.global_position)
		in_shelter = dist < 60.0  # umbral de 60 píxeles
	else:
		in_shelter = false

	# Tormenta
	if in_storm:
		if not in_shelter:
			current_health -= storm_damage * delta
			print("busca refugio")
			if current_health <= 0:
				current_health = 0
				print("El prisionero ha muerto por la tormenta.")
				queue_free()
	else:
		storm_timer -= delta
		if storm_timer <= 0:
			in_storm = true
			storm_timer = storm_interval
			print("¡Tormenta! Busca refugio.")
			await get_tree().create_timer(10.0).timeout
			in_storm = false
			print("La tormenta ha pasado.")

	# Movimiento controlado por el cerebro
	if brain:
		brain.execute()

	# Aplicar movimiento
	if moving:
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		if global_position.distance_to(target_position) < 10.0:
			moving = false
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO

func _on_area_detected(area: Area2D) -> void:
	if area.is_in_group("roca") and not carrying_rock:
		carrying_rock = true
		area.queue_free()
		print("Roca recolectada. Llévala al almacén.")
	elif area.is_in_group("almacen") and carrying_rock:
		carrying_rock = false
		var storage = area
		if storage.has_method("store_rock"):
			storage.store_rock()
		print("Roca depositada en el almacén.")
	elif area.is_in_group("comida"):
		current_hunger = max_hunger
		area.queue_free()
		print("Comida consumida. Hambre restaurada.")
	# Eliminado el bloque del refugio aquí (ya no se usa)

func get_hunger() -> float:
	return current_hunger

# Eliminada _on_area_exited porque el refugio ya no depende de colisiones
