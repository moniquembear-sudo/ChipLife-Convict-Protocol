extends Area2D

func _ready() -> void:
	# Aseguramos que la roca esté en el grupo "roca"
	add_to_group("roca")
