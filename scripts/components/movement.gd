extends Node
class_name MovementComponent

var entity: CharacterBody2D
var target_position: Vector2 = Vector2.ZERO
var moving: bool = false
var speed: float = 200.0

func setup(parent: CharacterBody2D) -> void:
	entity = parent
	speed = parent.speed if "speed" in parent else 200.0

func move_to(pos: Vector2) -> void:
	target_position = pos
	moving = true

func stop() -> void:
	moving = false
	entity.velocity = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	print("Movement: moving=", moving, " entity=", entity)
	if not moving or not entity:
		entity.velocity = Vector2.ZERO
		return
	
	var direction = (target_position - entity.global_position).normalized()
	entity.velocity = direction * speed
	entity.move_and_slide()
	
	if entity.global_position.distance_to(target_position) < 10.0:
		stop()
