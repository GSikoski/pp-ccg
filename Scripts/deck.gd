extends Node2D

var player_deck = ["Food", "Food", "Food", "Food", "Food", "Food", "Food", "Food", "Food"]
const CARD_SCENE_PATH = "res://Scenes/card.tscn" 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func draw_card():
	var card_drawn = player_deck[0]
	player_deck.erase(card_drawn)
	
	if player_deck.size() <= 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
	
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../PlayerHand".add_card_to_hand(new_card)
	if card_drawn == "Food":
		new_card.value = 2
		new_card.get_node("Value").text = str(new_card.value)
