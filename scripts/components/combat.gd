extends Node
class_name CombatComponent

var entity: Entity
var attack_damage: float = 10.0
var attack_range: float = 40.0
var attack_cooldown: float = 1.0
var current_cooldown: float = 0.0

func setup(parent: Entity) -> void:
	entity = parent

func _physics_process(delta: float) -> void:
	if current_cooldown > 0:
		current_cooldown -= delta

func attack(target: Node2D) -> void:
	if current_cooldown > 0: return
	if entity.global_position.distance_to(target.global_position) > attack_range: return
	
	if target.has_method("take_damage"):
		target.take_damage(attack_damage)
		current_cooldown = attack_cooldown
		print("¡Ataque realizado!")
