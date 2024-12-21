extends Node2D

var card_manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_manager = $"../CardManager"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
