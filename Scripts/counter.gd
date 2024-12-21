extends Node2D
var card_manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_manager = $"../CardManager"

func update_total():
	$Total.text = "Total Value: " + str(card_manager.selected_value)
