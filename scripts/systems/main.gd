extends Node2D

@onready var background: ColorRect = $Background
@onready var spawn_timer: Timer = $CreatureSpawnTimer


func _ready() -> void:
	# Conectar a las señales del reloj global
	TimeManager.day_night_changed.connect(_on_day_night_changed)
	# Aplicar el color inicial
	_on_day_night_changed(TimeManager.is_day)
	spawn_timer.timeout.connect(_spawn_creature)

func _on_day_night_changed(is_day: bool) -> void:
	if is_day:
		# Color de día (celeste claro)
		background.color = Color(0.6, 0.8, 1.0)
	else:
		# Color de noche (azul oscuro)
		background.color = Color(0.1, 0.1, 0.3)

func _spawn_creature() -> void:
	var creature_scene = load("res://scenes/entities/creature.tscn")
	var c = creature_scene.instantiate()
	# Aparece en un borde aleatorio del mapa
	c.global_position = Vector2(randf_range(-500, 500), randf_range(-500, 500))
	add_child(c)
	print("¡Una criatura ha aparecido!")
