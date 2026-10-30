extends Area2D

# Contador global de piedras (accesible desde otros scripts)
var stored_rocks: int = 0

func _ready() -> void:
	add_to_group("almacen")

func store_rock() -> void:
	stored_rocks += 1
	print("Piedras almacenadas: ", stored_rocks)
