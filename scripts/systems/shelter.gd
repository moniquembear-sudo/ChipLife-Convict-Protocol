extends Area2D

func _ready() -> void:
	add_to_group("refugio")
	# Conectamos las señales de entrada y salida
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Entity:
		body.in_shelter = true
		print("Entidad entró al refugio")

func _on_body_exited(body: Node2D) -> void:
	if body is Entity:
		body.in_shelter = false
		print("Entidad salió del refugio")
