extends Node2D

var panda_deck = ["Panda", "Panda", "Panda", "Panda", "Panda", "Panda"]
const CARD_SCENE_PATH = "res://Scenes/buyable_panda.tscn"
var panda_on_table = false
const PANDA_POS = Vector2(544, 245)
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_card()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_card_to_board(new_card):
	var tween = get_tree().create_tween()
	tween.tween_property(new_card, "position", PANDA_POS, 0.1)

func draw_card():
	print("Panda drawn")
	var card_drawn = panda_deck[0]
	panda_deck.erase(card_drawn)
	
	if panda_deck.size() <= 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
	
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	$"../PandaManager".add_child(new_card)
	new_card.name = "Panda"
	if card_drawn == "Panda":
		new_card.cost = 5
		new_card.get_node("Cost").text = str(new_card.cost)
	add_card_to_board(new_card)
