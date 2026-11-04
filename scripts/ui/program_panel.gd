extends Panel

# Referencia al prisionero actual (por ahora solo 1)
var prisoner: CharacterBody2D

# Lista de acciones (columnas de la tabla)
var actions: Array[String] = ["Recolectar", "Transportar", "Comer", "Refugiarse", "Descansar"]

# Contenedor donde irá la tabla generada por código
@onready var table_scroll: ScrollContainer = $TableScroll
var grid: GridContainer

func _ready() -> void:
	# Creamos un GridContainer dentro del ScrollContainer
	grid = GridContainer.new()
	grid.columns = actions.size() + 1 # +1 por la columna del nombre
	grid.custom_minimum_size = Vector2(0, 100) # Tamaño mínimo para que se vea bien
	table_scroll.add_child(grid)
	_build_table()
	
	# Conectar botones
	$CloseButton.pressed.connect(_on_close_pressed)
	$ApplyButton.pressed.connect(_on_apply_pressed)
	
	# Ocultar el panel al inicio (se abrirá con un botón)
	hide()
	add_to_group("work_panel")

func open_panel(target_prisoner: CharacterBody2D) -> void:
	prisoner = target_prisoner
	#_on_apply_pressed()
	show()
	
func _build_table() -> void:
	# 1. Limpiar tabla anterior
	for child in grid.get_children():
		child.queue_free()
	
	# 2. Crear encabezados (fila 0)
	var empty_label = Label.new()
	empty_label.text = "Recluso"
	empty_label.add_theme_color_override("font_color", Color.RED)
	grid.add_child(empty_label)
	
	for action in actions:
		var label = Label.new()
		label.text = action
		label.add_theme_color_override("font_color", Color.RED)
		grid.add_child(label)
		
	# NUEVO: Encabezado de Acciones
	var action_header = Label.new()
	action_header.text = "Acciones"
	action_header.add_theme_color_override("font_color", Color.RED)
	grid.add_child(action_header)
	
	# 3. Crear la fila del prisionero (fila 1)
	var name_label = Label.new()
	name_label.text = "Recluso 01"
	name_label.add_theme_color_override("font_color", Color.GREEN)
	grid.add_child(name_label)
	
	var default_priorities = {
		"Recolectar": "1",
		"Transportar": "2",
		"Comer": "3",
		"Refugiarse": "0",
		"Descansar": "0"
	}
	for action in actions:
		var btn = Button.new()
		btn.text = default_priorities.get(action, "0")
		btn.custom_minimum_size = Vector2(45, 45)
		btn.name = action 
		btn.pressed.connect(_on_priority_button_pressed.bind(btn))
		grid.add_child(btn)
		
	# NUEVO: Botón de Programar
	var program_btn = Button.new()
	program_btn.text = "Programar"
	program_btn.custom_minimum_size = Vector2(100, 45)
	program_btn.pressed.connect(_on_program_button_pressed)
	grid.add_child(program_btn)

func _on_apply_pressed() -> void:
	if not prisoner or not prisoner.has_node("Brain"):
		return
		
	var brain = prisoner.get_node("Brain")
	var new_priorities: Array[String] = []
	
	# Recolectamos los valores del 1 al 5
	var priorities_dict: Dictionary = {}

	for action in actions:
		var btn = grid.get_node(action) as Button
		if btn:
			var priority_value = int(btn.text)
			if priority_value > 0:
				# Guardamos en un diccionario temporal: Prioridad -> Acción
				# Si hay empate (dos acciones con prioridad 1), se ejecuta la primera de izquierda a derecha
				if not priorities_dict.has(priority_value):
					priorities_dict[priority_value] = []
				priorities_dict[priority_value].append(action.to_lower())
	
	# Construimos el array final ordenado numéricamente (1, 2, 3...)
	var sorted_keys = priorities_dict.keys()
	sorted_keys.sort()
	
	for key in sorted_keys:
		for action_name in priorities_dict[key]:
			new_priorities.append(action_name)
			
	# Añadimos "descansar" al final si no tiene prioridad o como fallback
	if not "descansar" in new_priorities:
		new_priorities.append("descansar")
	
	# Enviamos al cerebro
	brain.set_priorities(new_priorities)
	print("Nuevas prioridades aplicadas: ", new_priorities)
	
	# Opcional: cerrar el panel tras aplicar
	# _on_close_pressed()

func _on_close_pressed() -> void:
	hide()

func _on_priority_button_pressed(btn: Button) -> void:
	var current_val = int(btn.text)
	# Ciclo: 0 -> 1 -> 2 -> 3 -> 0
	current_val = (current_val + 1) % 4
	btn.text = str(current_val)

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

func _on_program_button_pressed() -> void:
	if prisoner:
		# Buscamos el panel de código en la escena y lo abrimos
		var code_panel = get_tree().get_first_node_in_group("code_panel")
		if code_panel:
			code_panel.open_panel(prisoner)
		else:
			print("ERROR: No se encontró el CodePanel")

# Necesitamos actualizar get_current_priorities para que ignore la nueva columna
# (Como los botones tienen nombre de acción, el código actual sigue funcionando perfectamente).
