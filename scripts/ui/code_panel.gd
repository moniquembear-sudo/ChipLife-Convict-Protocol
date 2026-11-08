extends Panel

var entity: Entity
var current_threshold: int = 30

@onready var value_label: Label = $VBoxContainer/HBoxContainer/ValueLabel

func _ready() -> void:
	add_to_group("code_panel")
	$VBoxContainer/HBoxContainer2/ExitButton.pressed.connect(_on_exit_pressed)
	$VBoxContainer/HBoxContainer2/ApplyButton.pressed.connect(_on_apply_pressed)
	$VBoxContainer/HBoxContainer/MinusBtn.pressed.connect(_on_minus_pressed)
	$VBoxContainer/HBoxContainer/PlusBtn.pressed.connect(_on_plus_pressed)
	hide()

func open_panel(target_entity: Entity) -> void:
	entity = target_entity
	if entity.needs:
		current_threshold = entity.needs.hunger_threshold
	_update_label()
	show()

func _on_plus_pressed() -> void:
	if current_threshold < 90:
		current_threshold += 10
		_update_label()

func _on_minus_pressed() -> void:
	if current_threshold > 10:
		current_threshold -= 10
		_update_label()

func _update_label() -> void:
	value_label.text = str(current_threshold) + "%"

func _on_apply_pressed() -> void:
	if entity and entity.needs:
		entity.needs.hunger_threshold = current_threshold
		print("Nuevo umbral aplicado: ", current_threshold)
		hide()

func _on_exit_pressed() -> void:
	hide()
