extends Node2D

signal left_click_mouse_button
signal left_release_mouse_button

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_DECK = 4
const COLLISION_MASK_BUY = 16


const STARTING_HAND_SIZE = 5

var card_manager_reference
var deck_reference

func _ready():
	card_manager_reference = $"../CardManager"
	deck_reference = $"../ResourceDeck"
	
	for i in range(STARTING_HAND_SIZE):
		deck_reference.draw_card()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_click_mouse_button")
			raycast_at_cursor()
		else:
			emit_signal("left_release_mouse_button")


func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var result_collision_mask = result[0].collider.collision_mask
		match result_collision_mask:
			COLLISION_MASK_CARD:
				var card_found = result[0].collider.get_parent()
				if card_found:
					card_manager_reference.start_select(card_found)
			COLLISION_MASK_DECK:
				deck_reference.draw_card()
			COLLISION_MASK_BUY:
				card_manager_reference.buy()
			
		
