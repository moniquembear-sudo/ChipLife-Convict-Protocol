extends CanvasLayer

@onready var hunger_bar: ProgressBar = $HungerBar

func _process(_delta: float) -> void:
	var prisoner = get_tree().get_first_node_in_group("prisionero")
	if prisoner and prisoner.has_method("get_hunger"):
		hunger_bar.value = prisoner.current_hunger
