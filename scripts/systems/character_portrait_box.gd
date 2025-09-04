extends Control

@export var char_name: String
@export var flip_image: bool
@export var can_hover: bool

@onready var bg_color = %BG_Color
@onready var image = %Portrait
@onready var character_ref = CharacterData.characters[char_name]

signal character_changed_to(arg: String)

func _ready() -> void:
	if char_name and character_ref:
		%Portrait.texture = CharacterData.characters[char_name]["portraits"]["portrait"]
		%BG_Color.color = CharacterData.characters[char_name]["bg_color_code"]
	if flip_image:
		%Portrait.flip_h = true


func _on_mouse_entered() -> void:
	if can_hover:
		SceneManager.play_hover_sfx()
		scale = Vector2(1.1, 1.1)
		z_index += 1

func _on_mouse_exited() -> void:
	if can_hover:
		scale = Vector2(1, 1)
		z_index -= 1


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if can_hover:
			SceneManager.play_click_sfx()
			emit_signal("character_changed_to", char_name)
