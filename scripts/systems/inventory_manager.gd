extends Node

var rocks: int = 0
var metal: int = 0

signal inventory_changed

func add_rock(amount: int = 1) -> void:
	rocks += amount
	inventory_changed.emit()

func add_metal(amount: int = 1) -> void:
	metal += amount
	inventory_changed.emit()