extends Entity
class_name Prisoner

@export var speed: float = 200.0
@export var max_hunger: float = 100.0
@export var hunger_decay_rate: float = 2.0
@export var max_health: float = 100.0
@export var storm_interval: float = 10.0
@export var storm_damage: float = 10.0

var carrying_rock: bool = false
var hunger_threshold: int = 30

func _ready() -> void:
	super._ready()
	add_to_group("prisionero")
	# Asignar referencias a los componentes
	if needs:
		needs.current_hunger = needs.max_hunger
		needs.current_health = needs.max_health
