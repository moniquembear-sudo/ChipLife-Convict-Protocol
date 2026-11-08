extends Node
class_name MovementComponent

var entity: Entity
var target_position: Vector2 = Vector2.ZERO
var moving: bool = false
var speed: float = 200.0

func setup(parent: Entity) -> void:
	entity = parent

func move_to(pos: Vector2) -> void:
	target_position = pos
	moving = true

func stop() -> void:
	moving = false
	entity.velocity = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	if not moving or not entity:
		return
	
	var direction = (target_position - entity.global_position).normalized()
	entity.velocity = direction * speed
	entity.move_and_slide()
	
	if entity.global_position.distance_to(target_position) < 10.0:
		stop()
