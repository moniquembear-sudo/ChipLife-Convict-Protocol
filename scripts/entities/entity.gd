extends CharacterBody2D
class_name Entity

var carrying_rock: bool = false

@onready var brain: Node = $Brain
@onready var movement: Node = $Movement
@onready var needs: Node = $Needs if has_node("Needs") else null
@onready var energy: Node = $Energy if has_node("Energy") else null
@onready var storm_manager: Node = $StormManager if has_node("StormManager") else null
@onready var combat: Node = $Combat if has_node("Combat") else null
@onready var morale: Node = $Morale if has_node("Morale") else null

func _ready() -> void:
	add_to_group("entities")
	if brain: brain.setup(self)
	if movement: movement.setup(self)
	if needs: needs.setup(self)
	if energy: energy.setup(self)
	if storm_manager: storm_manager.setup(self)
	if combat: combat.setup(self)
	if morale: morale.setup(self)

func _physics_process(_delta: float) -> void:
	if brain: brain.execute()
