extends RigidBody2D

@onready var shirt_sprite = $Sprite2D
@onready var word_label = $Label

var theme: String
var dragging: bool = false
var last_mouse_pos: Vector2
var mouse_speed: Vector2

func set_shirt(image: Texture2D, word: String, theme_name: String):
	shirt_sprite.texture = image
	word_label.text = word
	theme = theme_name

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		dragging = true
		freeze = true
		last_mouse_pos = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseMotion and dragging:
		var current_pos = get_global_mouse_position()
		mouse_speed = current_pos - last_mouse_pos
		global_position = current_pos
		last_mouse_pos = current_pos
	
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and dragging:
		# RELEASE
		dragging = false
		# Ensure the body knows its last position before unfreezing
		PhysicsServer2D.body_set_state(get_rid(), PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D(rotation, global_position))
		freeze = false
		linear_velocity = mouse_speed * 10  # Adjust multiplier
