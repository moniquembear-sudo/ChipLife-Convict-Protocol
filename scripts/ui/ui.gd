extends CanvasLayer

@onready var hunger_fill: ColorRect = $HungerBarFill
@onready var hunger_label: Label = $HungerLabel
@onready var game_over_label: Label = $GameOverLabel
@onready var storm_label: Label = $StormLabel
@onready var open_program_button: Button = $OpenProgramButton
@onready var work_panel = $WorkPanel
@onready var time_label: Label = $TimeLabel
@onready var resources_label: Label = $ResourcesLabel
@onready var morale_fill: ColorRect = $MoraleBarFill
@onready var research_button: Button = $ResearchButton
@onready var research_panel: Panel = $ResearchPanel

func _ready() -> void:
	game_over_label.text = ""
	open_program_button.pressed.connect(_on_open_program_pressed)
	TimeManager.time_changed.connect(_on_time_changed)
	_on_time_changed(TimeManager.current_hour, TimeManager.current_minute)
	InventoryManager.inventory_changed.connect(_update_inventory_ui)
	_update_inventory_ui()
	research_button.pressed.connect(_on_research_pressed)

func _update_inventory_ui() -> void:
	if resources_label:
		resources_label.text = "Rocas: %d | Metal: %d | Créditos: %d" % [InventoryManager.rocks, InventoryManager.metal, InventoryManager.credits]

func _on_time_changed(_hour: int, _minute: int) -> void:
	time_label.text = TimeManager.get_time_string()
	
func _process(_delta: float) -> void:
	var entity = get_tree().get_first_node_in_group("player_entity") # <-- CAMBIO AQUÍ
	print("UI buscando entidad: ", entity)  # <-- AÑADIR
	if entity:
		print("Needs: ", entity.needs, " Morale: ", entity.morale)  # <-- AÑADIR
	if entity and is_instance_valid(entity) and not entity.is_queued_for_deletion():
		# Hambre
		if entity.needs:
			var hunger_percent = entity.needs.current_hunger / entity.needs.max_hunger
			hunger_fill.size.x = 200 * hunger_percent
			hunger_label.text = "Hambre: " + str(int(entity.needs.current_hunger))
		
		# Moral
		if entity.morale:
			var morale_percent = entity.morale.current_morale / entity.morale.max_morale
			morale_fill.size.x = 200 * morale_percent
			if morale_percent < 0.3:
				morale_fill.color = Color.RED
			else:
				morale_fill.color = Color.GREEN
		
		# Clima
		if WeatherManager.is_storm_active:
			storm_label.text = "¡TORMENTA!"
			storm_label.modulate = Color.RED
		elif WeatherManager.is_solar_flare_active:
			storm_label.text = "¡RADIACIÓN SOLAR!"
			storm_label.modulate = Color.PURPLE
		else:
			storm_label.text = "Clima estable"
			storm_label.modulate = Color.WHITE
	else:
		if game_over_label.text == "":
			game_over_label.text = "GAME OVER\nEl prisionero ha muerto."
			storm_label.text = ""


func _on_open_program_pressed() -> void:
	var entity = get_tree().get_first_node_in_group("entities")
	if entity and work_panel:
		work_panel.open_panel(entity)

func _on_research_pressed() -> void:
		research_panel.open_panel()
