extends Node2D

var screen_size
var is_hovering_on_card
var player_hand
var selected_cards = []

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_SLOT = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand = $"../PlayerHand"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_highest_card(result)
	return null
	
func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 2
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null
	
func get_highest_card(result):
	var highest = null
	var height = -1
	for res in result:
		if res.collider.get_parent().z_index > height:
			highest = res.collider.get_parent()
	return highest

func connect_card_signals(card):
	card.connect("hover", on_hover)
	card.connect("hover_off", off_hover)
	
func on_hover(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)
	
func off_hover(card):
	var temp_card = raycast_check_for_card()
	highlight_card(card, false)
	if temp_card:
		highlight_card(temp_card, true)
	else:
		is_hovering_on_card = false

func highlight_card(card, is_hover):
	if is_hover:
		card.scale = Vector2(1.05, 1.05 )
		card.z_index = 2
	else:
		card.scale = Vector2(1,1)
		card.z_index = 1
		
	
func start_select(card):
	if card not in selected_cards:
		selected_cards.append(card)
		card.scale = Vector2(1.1, 1.1)
		print("card was selected")
	else:
		selected_cards.erase(card)
		card.scale = Vector2(1, 1)
		print("card was de-selected")
