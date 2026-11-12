extends Node

signal research_unlocked(id: String)

var unlocked_chips: bool = false
var unlocked_suits: bool = false

func unlock_chips() -> void:
	if InventoryManager.credits >= 150 and not unlocked_chips:
		InventoryManager.credits -= 150
		InventoryManager.inventory_changed.emit()
		unlocked_chips = true
		research_unlocked.emit("chips")
		print("¡Chips de recolección desbloqueados! Entidades más rápidas.")

func unlock_suits() -> void:
	if InventoryManager.credits >= 200 and not unlocked_suits:
		InventoryManager.credits -= 200
		InventoryManager.inventory_changed.emit()
		unlocked_suits = true
		research_unlocked.emit("suits")
		print("¡Trajes espaciales desbloqueados! Menos daño climático.")