extends Node2D

var card_being_dragged
var screen_size
var is_hovering_on_card
var player_hand

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_SLOT = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand = $"../PlayerHand"
	$"../InputManager".connect("left_release_mouse_button", on_left_click_release)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_position = get_global_mouse_position()
		card_being_dragged.position = mouse_position
		card_being_dragged.position = Vector2(
			clamp(mouse_position.x, 0, screen_size.x), 
			clamp(mouse_position.y, 0, screen_size.y)
			)




#func _input(event):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed:
			#var card = raycast_check_for_card()
			#if card:
				#start_drag(card)
		#else:
			#if card_being_dragged: finish_drag()

func on_left_click_release():
	if card_being_dragged: finish_drag()



func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#return result[0].collider.get_parent()
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
	if !card_being_dragged:
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
		
func start_drag(card):
	card_being_dragged = card
	card_being_dragged.scale = Vector2(1, 1)
	
func finish_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05)
	var slot = raycast_check_for_card_slot()
	if slot and !slot.card_in_slot:
		slot.card_in_slot = true
		card_being_dragged.position = slot.position
		card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		player_hand.remove_card_from_hand(card_being_dragged)
	else:
		player_hand.add_card_to_hand(card_being_dragged)
	card_being_dragged = null
