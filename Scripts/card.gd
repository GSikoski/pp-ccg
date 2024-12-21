extends Node2D

signal hover
signal hover_off

var hand_pos
var value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect_card_signals(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	emit_signal("hover", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hover_off", self)
