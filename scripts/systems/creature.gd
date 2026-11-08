extends CharacterBody2D

var target: Node2D = null
var speed: float = 100.0
var health: float = 30.0
var attack_damage: float = 5.0
var attack_cooldown: float = 0.0

func _ready() -> void:
	add_to_group("creatures")

func _physics_process(delta: float) -> void:
	if attack_cooldown > 0:
		attack_cooldown -= delta
	
	# Buscar objetivo si no tiene o si murió
	if not is_instance_valid(target):
		_find_nearest_target()
	
	if target and is_instance_valid(target):
		var dist = global_position.distance_to(target.global_position)
		if dist > 40.0:
			# Moverse hacia el objetivo
			var dir = (target.global_position - global_position).normalized()
			velocity = dir * speed
			move_and_slide()
		else:
			# Atacar
			velocity = Vector2.ZERO
			if attack_cooldown <= 0:
				if target.needs:
					target.needs.current_health -= attack_damage
					print("Criatura ataca a ", target.name)
					attack_cooldown = 1.5
					if target.needs.current_health <= 0:
						target.queue_free()

func _find_nearest_target() -> void:
	var nearest = null
	var min_dist = INF
	for e in get_tree().get_nodes_in_group("entities"):
		var d = global_position.distance_to(e.global_position)
		if d < min_dist:
			min_dist = d
			nearest = e
	target = nearest

func take_damage(amount: float) -> void:
	health -= amount
	print("Criatura recibe ", amount, " de daño. Salud: ", health)
	if health <= 0:
		print("Criatura eliminada.")
		queue_free()
