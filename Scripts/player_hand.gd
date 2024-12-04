extends Node2D

#const HAND_COUNT = 2
const CARD_SCENE_PATH = "res://Scenes/card.tscn"
var PLAYER_HAND = []
var SCREEN_CENTER_X
var CARD_WIDTH = 200
var HAND_Y_POSITION = 890 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SCREEN_CENTER_X = get_viewport().size.x / 2
	#var card_scene = preload(CARD_SCENE_PATH)
	#for i in range(HAND_COUNT):
		#var new_card = card_scene.instantiate()
		#$"../CardManager".add_child(new_card)
		#new_card.name = "Card"
		#add_card_to_hand(new_card)

func add_card_to_hand(card):
	if card not in PLAYER_HAND:
		PLAYER_HAND.insert(0,card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.hand_pos)

func update_hand_positions():
	for i in range(PLAYER_HAND.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = PLAYER_HAND[i]
		card.hand_pos = new_position
		animate_card_to_position(card, new_position)

func calculate_card_position(index):
	var x_offset = (PLAYER_HAND.size() - 1 * CARD_WIDTH) 
	var x_position = SCREEN_CENTER_X + index * CARD_WIDTH - x_offset
	return x_position
	
func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)

func remove_card_from_hand(card):
	if card in PLAYER_HAND:
		PLAYER_HAND.erase(card)
		update_hand_positions()
