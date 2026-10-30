extends CharacterBody2D

@export var speed: float = 200.0
@export var max_hunger: float = 100.0
@export var hunger_decay_rate: float = 2.0  # puntos por segundo
@export var max_health: float = 100.0

@onready var rock_detector: Area2D = $RockDetector

var target_position: Vector2 = Vector2.ZERO
var moving: bool = false
var carrying_rock: bool = false

var current_hunger: float = 100.0
var current_health: float = 100.0

func _ready() -> void:
	if rock_detector:
		rock_detector.area_entered.connect(_on_area_detected)
	current_hunger = max_hunger
	current_health = max_health
	add_to_group("prisionero")

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		target_position = get_global_mouse_position()
		moving = true
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		target_position = get_global_mouse_position()
		moving = true

func _physics_process(delta: float) -> void:
	# Movimiento
	if moving:
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		if global_position.distance_to(target_position) < 10.0:
			moving = false
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO

	# Hambre
	current_hunger -= hunger_decay_rate * delta
	current_hunger = clamp(current_hunger, 0, max_hunger)
	if current_hunger <= 0:
		current_health -= 5.0 * delta
		current_health = clamp(current_health, 0, max_health)
		if current_health <= 0:
			print("El prisionero ha muerto de hambre.")
			queue_free()

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
		# Comer
		current_hunger = max_hunger
		area.queue_free()
		print("Comida consumida. Hambre restaurada.")
