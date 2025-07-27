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

func set_data(eng: String, jpn: String, word_type: String):
	eng_text = eng
	jpn_text = jpn
	type = word_type
	text = eng
	visible_characters = 0  # Start hidden for typewriter
	_update_collision_size()

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

func _process(delta: float) -> void:
	if popup_instance:
		popup_instance.global_position = get_global_mouse_position() + Vector2(0, -60)

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


func force_full_reveal():
	finished_typing = true
	current_visible = eng_text.length()
	visible_characters = eng_text.length()
	await get_tree().process_frame
	_update_collision_size()


# --- HOVER LOGIC ---
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
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		SceneManager.play_click_sfx()
		# Later: DialogueManager.open_dictionary(eng_text, jpn_text)
