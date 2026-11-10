extends Area2D

var trade_timer: float = 0.0
var is_present: bool = false

func _ready() -> void:
	add_to_group("merchant_ship")
	body_entered.connect(_on_body_entered)
	hide() # Empieza oculta
	# Desactivar colisión mientras está oculta
	$CollisionShape2D.set_deferred("disabled", true)

func _process(delta: float) -> void:
	if is_present: return
	
	trade_timer += delta
	# Aparece cada 120 segundos (2 minutos reales)
	if trade_timer >= 60.0:
		_arrive()

func _arrive() -> void:
	is_present = true
	show()
	$CollisionShape2D.set_deferred("disabled", false)
	print("¡Nave mercante ha llegado! Ven a comerciar.")

func _on_body_entered(body: Node2D) -> void:
	if body is Entity and is_present:
		var trade_panel = get_tree().get_first_node_in_group("trade_panel")
		if trade_panel:
			trade_panel.open_panel()
			print("Abriendo tienda...")

func _depart() -> void:
	is_present = false
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	trade_timer = 0.0
	print("La nave mercante se ha ido.")
