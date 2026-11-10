extends Panel

@onready var credits_label: Label = $CreditsLabel
@onready var buy_prisoner_btn: Button = $BuyPrisonerBtn
@onready var buy_droid_btn: Button = $BuyDroidBtn
@onready var close_btn: Button = $CloseBtn



func _ready() -> void:
	add_to_group("trade_panel")
	buy_prisoner_btn.pressed.connect(_on_buy_prisoner)
	buy_droid_btn.pressed.connect(_on_buy_droid)
	close_btn.pressed.connect(_on_close)
	hide()
	$SellAllBtn.pressed.connect(_on_sell_all)
  

func open_panel() -> void:
	_update_credits()
	show()

func _update_credits() -> void:
	credits_label.text = "Créditos: " + str(InventoryManager.credits)

func _on_buy_prisoner() -> void:
	if InventoryManager.credits >= 100:
		InventoryManager.credits -= 100
		InventoryManager.inventory_changed.emit()
		_spawn_entity("res://scenes/entities/prisoner.tscn")
		print("Prisionero comprado.")
		_update_credits()
	else:
		print("No tienes suficientes créditos.")

func _on_buy_droid() -> void:
	if InventoryManager.credits >= 50:
		InventoryManager.credits -= 50
		InventoryManager.inventory_changed.emit()
		_spawn_entity("res://scenes/entities/droid.tscn")
		print("Droide comprado.")
		_update_credits()
	else:
		print("No tienes suficientes créditos.")

func _spawn_entity(path: String) -> void:
	var scene = load(path)
	if scene:
		var new_entity = scene.instantiate()
		# Aparece cerca de la nave (asumiendo que la nave está en el grupo merchant_ship)
		var ship = get_tree().get_first_node_in_group("merchant_ship")
		if ship:
			new_entity.global_position = ship.global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
		else:
			new_entity.global_position = Vector2.ZERO
		get_tree().current_scene.add_child(new_entity)

func _on_close() -> void:
	hide()

func _on_sell_all() -> void:
	var total_rocks = InventoryManager.rocks
	var total_metal = InventoryManager.metal
	if total_rocks > 0 or total_metal > 0:
		var ganancias = (total_rocks * 5) + (total_metal * 15)
		InventoryManager.rocks = 0
		InventoryManager.metal = 0
		InventoryManager.add_credits(ganancias)
		print("Vendido: ", total_rocks, " rocas, ", total_metal, " metales. Ganancia: ", ganancias)
		_update_credits()
	else:
		print("No hay recursos para vender.")
