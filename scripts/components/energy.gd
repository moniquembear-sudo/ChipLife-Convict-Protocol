extends Node
class_name EnergyComponent

var entity: Entity
var max_energy: float = 100.0
var current_energy: float = 100.0
var energy_decay_rate: float = 1.0
var energy_threshold: int = 20

func setup(parent: Entity) -> void:
	entity = parent
	current_energy = max_energy

func _physics_process(delta: float) -> void:
	current_energy -= energy_decay_rate * delta
	current_energy = clamp(current_energy, 0, max_energy)
	
	if current_energy <= 0:
		print("Droide sin energía. Apagado.")
		entity.movement.stop()
		# En el futuro, aquí el droide se apagaría por completo
