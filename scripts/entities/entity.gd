extends CharacterBody2D
class_name Entity

# Componentes (se asignan como hijos en la escena)
@onready var movement: Node = $Movement if has_node("Movement") else null
@onready var needs: Node = $Needs if has_node("Needs") else null
@onready var storm_manager: Node = $StormManager if has_node("StormManager") else null

# Referencia al cerebro
@onready var brain: Node = $Brain

func _ready() -> void:
	add_to_group("entity")
	if movement:
		movement.setup(self)
	if needs:
		needs.setup(self)
	if storm_manager:
		storm_manager.setup(self)
	if brain:
		brain.setup(self)