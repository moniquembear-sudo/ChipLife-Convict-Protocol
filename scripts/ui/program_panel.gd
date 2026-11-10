extends Panel

var entity: Entity
var actions: Array[String] = ["Defender", "Recolectar", "Minar", "Transportar", "Comer", "Refugiarse", "Comerciar", "Descansar"]
var grid: GridContainer

@onready var table_scroll: ScrollContainer = $TableScroll

func _ready() -> void:
	grid = GridContainer.new()
	grid.columns = actions.size() + 2 # +1 por nombre, +1 por botón programar
	grid.custom_minimum_size = Vector2(0, 100)
	table_scroll.add_child(grid)
	
	_build_table()
	
	$CloseButton.pressed.connect(_on_close_pressed)
	$ApplyButton.pressed.connect(_on_apply_pressed)
	hide()
	add_to_group("work_panel")

func open_panel(target_entity: Entity) -> void:
	entity = target_entity
	show()

func _build_table() -> void:
	for child in grid.get_children():
		child.queue_free()
	
	# Encabezados
	var empty_label = Label.new()
	empty_label.text = "Recluso"
	empty_label.add_theme_color_override("font_color", Color.RED)
	grid.add_child(empty_label)
	
	for action in actions:
		var label = Label.new()
		label.text = action
		label.add_theme_color_override("font_color", Color.RED)
		grid.add_child(label)
		
	var action_header = Label.new()
	action_header.text = "Acciones"
	action_header.add_theme_color_override("font_color", Color.RED)
	grid.add_child(action_header)
	
	# Fila del prisionero
	var name_label = Label.new()
	name_label.text = "Recluso 01"
	name_label.add_theme_color_override("font_color", Color.GREEN)
	grid.add_child(name_label)
	
	var default_priorities = {"Recolectar": "1", "Transportar": "2", "Comer": "3", "Refugiarse": "0", "Descansar": "0"}
	
	for action in actions:
		var btn = Button.new()
		btn.text = default_priorities.get(action, "0")
		btn.custom_minimum_size = Vector2(45, 45)
		btn.name = action 
		btn.pressed.connect(_on_priority_button_pressed.bind(btn))
		grid.add_child(btn)
		
	var program_btn = Button.new()
	program_btn.text = "Programar"
	program_btn.custom_minimum_size = Vector2(100, 45)
	program_btn.pressed.connect(_on_program_button_pressed)
	grid.add_child(program_btn)

func _on_priority_button_pressed(btn: Button) -> void:
	btn.text = str((int(btn.text) + 1) % 4)

func _on_apply_pressed() -> void:
	if not entity or not entity.brain: return
	
	var priorities_dict: Dictionary = {}
	for action in actions:
		var btn = grid.get_node(action) as Button
		if btn:
			var val = int(btn.text)
			if val > 0:
				if not priorities_dict.has(val): priorities_dict[val] = []
				priorities_dict[val].append(action.to_lower())
				
	var new_priorities: Array[String] = []
	var sorted_keys = priorities_dict.keys()
	sorted_keys.sort()
	
	for key in sorted_keys:
		for action_name in priorities_dict[key]:
			new_priorities.append(action_name)
			
	if not "descansar" in new_priorities:
		new_priorities.append("descansar")
		
	entity.brain.set_priorities(new_priorities)
	print("Prioridades aplicadas: ", new_priorities)
	hide()

func _on_close_pressed() -> void:
	hide()

func _on_program_button_pressed() -> void:
	if entity:
		var code_panel = get_tree().get_first_node_in_group("code_panel")
		if code_panel:
			code_panel.open_panel(entity)

func get_current_priorities() -> Array[String]:
	var priorities_dict: Dictionary = {}
	for action in actions:
		var btn = grid.get_node(action) as Button
		if btn:
			var priority_value = int(btn.text)
			if priority_value > 0:
				if not priorities_dict.has(priority_value):
					priorities_dict[priority_value] = []
				priorities_dict[priority_value].append(action.to_lower())
	var sorted_keys = priorities_dict.keys()
	sorted_keys.sort()
	var new_priorities: Array[String] = []
	for key in sorted_keys:
		for action_name in priorities_dict[key]:
			new_priorities.append(action_name)
	if not "descansar" in new_priorities:
		new_priorities.append("descansar")
	return new_priorities
