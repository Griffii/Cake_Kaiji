extends Label

@onready var area = $Area2D
@onready var collision = $Area2D/CollisionShape2D
@onready var hover_popup_scene = preload("res://scenes/ui/hint_popup.tscn")

var eng_text = ""
var jpn_text = ""
var type = ""
var popup_instance: Control = null
var visible_chars = 0
var current_visible = 0
var finished_typing = false

# Colors for each part of speech
const COLOR_NOUN       = Color("#4CAF50")  # Green
const COLOR_VERB       = Color("#2196F3")  # Blue
const COLOR_ADJECTIVE  = Color("#E91E63")  # Pink
const COLOR_ADVERB     = Color("#9C27B0")  # Purple
const COLOR_PRONOUN    = Color("#FF9800")  # Orange
const COLOR_PREPOSITION= Color("#009688")  # Teal
const COLOR_CONJUNCTION= Color("#3F51B5")  # Indigo
const COLOR_INTERJECTION=Color("#F44336")  # Red
const COLOR_DETERMINER = Color("#795548")  # Brown
const COLOR_PHRASE     = Color("#607D8B")  # Gray


func set_data(word_type: String, eng: String, jpn: String):
	type = word_type
	eng_text = eng
	jpn_text = jpn
	
	text = eng
	visible_characters = 0  # Start hidden for typewriter
	_update_collision_size()
	set_background_color_by_type()

func is_finished():
	return finished_typing

func get_eng_text_length() -> int:
	return eng_text.length()


func _ready():
	area.mouse_entered.connect(_on_mouse_entered)
	area.mouse_exited.connect(_on_mouse_exited)
	area.input_event.connect(_on_input_event)
	
	if collision.shape:
		collision.shape = collision.shape.duplicate() # Ensure unique shape
	

func _process(_delta: float) -> void:
	if popup_instance:
		popup_instance.global_position = get_global_mouse_position() + Vector2(0, -60)

# --- BACKGROUND COLOR LOGIC ___
func set_background_color_by_type():
	var bg_color: Color
	
	match type:
		"noun": bg_color = COLOR_NOUN
		"verb": bg_color = COLOR_VERB
		"adjective": bg_color = COLOR_ADJECTIVE
		"adverb": bg_color = COLOR_ADVERB
		"pronoun": bg_color = COLOR_PRONOUN
		"preposition": bg_color = COLOR_PREPOSITION
		"conjunction": bg_color = COLOR_CONJUNCTION
		"interjection": bg_color = COLOR_INTERJECTION
		"determiner": bg_color = COLOR_DETERMINER
		"phrase": bg_color = COLOR_PHRASE
		_: bg_color = Color.WHITE
	
	var stylebox = get_theme_stylebox("normal", "Label")
	if stylebox:
		var unique_stylebox = stylebox.duplicate()
		
		# Make background transparent
		bg_color.a = 0.0
		unique_stylebox.bg_color = bg_color
		# Make borders transparent
		unique_stylebox.border_color = Color(0, 0, 0, 0) # Full alpha
		
		add_theme_stylebox_override("normal", unique_stylebox)

func reveal_background():
	var stylebox = get_theme_stylebox("normal", "Label")
	if stylebox:
		var new_stylebox = stylebox.duplicate()
		# Restore background fully opaque
		new_stylebox.bg_color.a = 1.0
		
		# Restore border to visible color (optional: black or based on type)
		new_stylebox.border_color = Color(0, 0, 0, 1) # Black border, fully visible
		add_theme_stylebox_override("normal", new_stylebox)



# Update Area2D collision to match current text width
func _update_collision_size():
	await get_tree().process_frame
	if collision.shape is RectangleShape2D:
		collision.shape.extents = size / 2
		area.position = size / 2


# --- TYPEWRITER SUPPORT ---
func set_visible_chars(count: int):
	count = clamp(count, 0, eng_text.length())
	if count == current_visible:
		finished_typing = true
		return
	current_visible = count
	visible_characters = count
	_update_collision_size()
	
	if count == 1:
		reveal_background()

func force_full_reveal():
	finished_typing = true
	current_visible = eng_text.length()
	visible_characters = eng_text.length()
	await get_tree().process_frame
	_update_collision_size()
	reveal_background()


# --- HOVER LOGIC ---
### ADD A DELAY BEFORE POP UP SHOWS!!! ###
func _on_mouse_entered():
	if popup_instance:
		popup_instance.queue_free()
	popup_instance = hover_popup_scene.instantiate()
	self.add_child(popup_instance)
	popup_instance.set_text(jpn_text)
	
	SceneManager.play_hover_sfx()
	scale = Vector2(1,1.05)

func _on_mouse_exited():
	if popup_instance:
		popup_instance.queue_free()
		popup_instance = null
	
	scale = Vector2(1,1)

# --- CLICK LOGIC ---
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		SceneManager.play_click_sfx()
		MenuManager.dictionary_search(eng_text)
		MenuManager.open_dictionary_menu()
		
		if popup_instance:
			popup_instance.queue_free()
			popup_instance = null
