extends Area2D

signal victory_reached

var stored_rocks: int = 0
const ROCKS_TO_WIN: int = 10

func _ready() -> void:
	add_to_group("almacen")

func store_rock() -> void:
	stored_rocks += 1
	print("Piedras almacenadas: ", stored_rocks)
	if stored_rocks >= ROCKS_TO_WIN:
		victory_reached.emit()
		print("¡VICTORIA! Has almacenado ", ROCKS_TO_WIN, " rocas.")
