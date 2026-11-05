extends CanvasLayer

@onready var hunger_fill: ColorRect = $HungerBarFill
@onready var hunger_label: Label = $HungerLabel
@onready var game_over_label: Label = $GameOverLabel
@onready var storm_label: Label = $StormLabel

@onready var apply_button: Button = $WorkPanel/ApplyButton
@onready var work_panel = $WorkPanel
@onready var open_program_button = $OpenProgramButton

func _ready() -> void:
	game_over_label.text = ""
	var storage = get_tree().get_first_node_in_group("almacen")
	if storage and storage.has_signal("victory_reached"):
		storage.victory_reached.connect(_on_victory)
	open_program_button.pressed.connect(_on_open_program_pressed)

func _process(_delta: float) -> void:
	var prisoner = get_tree().get_first_node_in_group("prisionero")
	if prisoner and is_instance_valid(prisoner) and not prisoner.is_queued_for_deletion():
		# Acceder a los componentes del prisionero
		if prisoner.needs:
			var hunger_percent = prisoner.needs.current_hunger / prisoner.needs.max_hunger
			hunger_fill.size.x = 200 * hunger_percent
			hunger_label.text = "Hambre: " + str(int(prisoner.needs.current_hunger))
		
		if prisoner.storm_manager:
			if prisoner.storm_manager.in_storm:
				storm_label.text = "¡TORMENTA!"
				storm_label.modulate = Color.RED
			else:
				var time_left = prisoner.storm_manager.storm_timer
				storm_label.text = "Tormenta en: " + str(int(time_left)) + "s"
				storm_label.modulate = Color.WHITE
	else:
		if game_over_label.text == "":
			game_over_label.text = "GAME OVER\nEl prisionero ha muerto."
			storm_label.text = ""

func _on_victory() -> void:
	game_over_label.text = "¡VICTORIA!\nHas almacenado 10 rocas."

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_apply_pressed() -> void:
	var prisoner = get_tree().get_first_node_in_group("prisionero")
	if prisoner and prisoner.has_node("Brain"):
		var brain = prisoner.get_node("Brain")
		var new_priorities: Array[String] = []
		brain.set_priorities(new_priorities)
		print("Prioridades aplicadas: ", new_priorities)

func _on_open_program_pressed() -> void:
	var prisoner = get_tree().get_first_node_in_group("prisionero")
	if prisoner:
		work_panel.open_panel(prisoner)
