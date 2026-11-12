extends Panel

@onready var chips_btn: Button = $BuyChipsBtn
@onready var suits_btn: Button = $BuySuitsBtn
@onready var close_btn: Button = $CloseResearchBtn
@onready var credits_label: Label = $CreditsLabel

func _ready() -> void:
	add_to_group("research_panel")
	chips_btn.pressed.connect(_on_buy_chips)
	suits_btn.pressed.connect(_on_buy_suits)
	close_btn.pressed.connect(_on_close)
	hide()

func open_panel() -> void:
	_update_credits()
	show()

func _update_credits() -> void:
	credits_label.text = "Créditos: " + str(InventoryManager.credits)
	if ResearchManager.unlocked_chips:
		chips_btn.text = "Chips (Ya desbloqueado)"
		chips_btn.disabled = true
	if ResearchManager.unlocked_suits:
		suits_btn.text = "Trajes (Ya desbloqueado)"
		suits_btn.disabled = true

func _on_buy_chips() -> void:
	ResearchManager.unlock_chips()
	_update_credits()

func _on_buy_suits() -> void:
	ResearchManager.unlock_suits()
	_update_credits()

func _on_close() -> void:
	hide()
