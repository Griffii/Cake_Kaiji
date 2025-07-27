extends CanvasLayer

@onready var dialogue_label: RichTextLabel = %DialogueText
@onready var name_label: Label = %NameLabel
@onready var portrait: TextureRect = %Portrait
@onready var hint_popup: Control = $HintPopup
@onready var anim_player = $AnimationPlayer

var dialogue_data: Array = []
var hint_dict: Dictionary = {}

var current_index = 0
var current_char_index = 0
var typing_speed = 0.05
var typing_timer = 0.0
var full_text = ""
var is_typing = false
var is_hovering_meta = false
var is_in_animation = false

var parsed_segments: Array = []  # stores {text: "...", tag_stack: [...]}
var visible_char_count = 0


# TEST DATA FOR TESTING
var test_hint_dict = {
	"cake": "ケーキ",
	"note": "メモ",
	"sorry": "ごめんなさい",
	"kitchen": "台所",
	"morning": "朝",
	"sister": "お姉さん",
	"guilty": "罪悪感がある"
}
var test_dialogue = [
	{
		"speaker": "Sosuke",
		"portrait": "res://scenes/characters/Sosuke/Sosuke_01.png",
		"text": "When I came home from school, my [url=hint:cake][color=yellow][u]cake[/u][/color][/url] was gone!",
		"speed": 0.05
	},
	{
		"speaker": "Sosuke",
		"portrait": "res://scenes/characters/Sosuke/Sosuke_01.png",
		"text": "There was only a [url=hint:note][color=yellow][u]note[/u][/color][/url] that said \"[url=hint:sorry][color=yellow][u]sorry[/u][/color][/url]\".",
		"speed": 0.04
	},
	{
		"speaker": "Mom",
		"portrait": "res://scenes/characters/Karin/Karin_Happy.png",
		"text": "Oh no! I was in the [url=hint:kitchen][color=yellow][u]kitchen[/u][/color][/url] this [url=hint:morning][color=yellow][u]morning[/u][/color][/url], but I didn’t see any cake.",
		"speed": 0.035
	},
	{
		"speaker": "Dad",
		"portrait": "res://scenes/characters/Ken/Ken_Serious.png",
		"text": "Maybe you should ask your [url=hint:sister][color=yellow][u]sister[/u][/color][/url]... she looked [url=hint:guilty][color=yellow][u]guilty[/u][/color][/url] earlier.",
		"speed": 0.025
	},
	{
		"speaker": "Sosuke",
		"portrait": "res://scenes/characters/Sosuke/Sosuke_01.png",
		"text": "I’ll figure this out. One clue at a time.",
		"speed": 0.03
	}
]


func _ready():
	# Empty the dialogue box and name box
	name_label.text = ""
	dialogue_label.text = ""

func start_dialogue(data: Array, hint_data: Dictionary):
	dialogue_data = data
	hint_dict = hint_data
	current_index = 0
	
	# Set first speaker name
	var entry = dialogue_data[current_index]
	name_label.text = entry.get("speaker", "")
	
	play_fade_in()
	
	await get_tree().create_timer(1).timeout
	_show_next_line()

func _show_next_line():
	if current_index >= dialogue_data.size():
		play_fade_out()
		return
	
	var entry = dialogue_data[current_index]
	name_label.text = entry.get("speaker", "")
	portrait.texture = load(entry.get("portrait", ""))
	full_text = entry.get("text", "")
	typing_speed = entry.get("speed", 0.05)
	dialogue_label.clear()
	dialogue_label.bbcode_enabled = true
	
	visible_char_count = 0
	typing_timer = 0.0
	is_typing = true
	
	parse_bbcode_segments(full_text)
	update_typed_text()

# Strip dialogue data of meta tags and return pre-formatted text for display
func parse_bbcode_segments(text: String):
	parsed_segments.clear()
	var tag_stack: Array = []
	var i = 0
	var current_text = ""
	
	while i < text.length():
		if text[i] == "[":
			# Flush current visible text
			if current_text != "":
				parsed_segments.append({ "text": current_text, "tags": tag_stack.duplicate() })
				current_text = ""
			
			# Read full tag
			var end = text.find("]", i)
			if end == -1:
				break  # malformed
			var tag = text.substr(i + 1, end - i - 1)
			
			if tag.begins_with("/"):
				# closing tag
				if tag_stack.size() > 0:
					tag_stack.pop_back()
			else:
				tag_stack.append(tag)
			i = end + 1
		else:
			current_text += text[i]
			i += 1
	
	# Catch remaining text
	if current_text != "":
		parsed_segments.append({ "text": current_text, "tags": tag_stack.duplicate() })
func update_typed_text():
	var typed_bbcode = ""
	var remaining = visible_char_count
	
	for segment in parsed_segments:
		var tag_prefix = ""
		for tag in segment["tags"]:
			tag_prefix += "[" + tag + "]"
		var tag_suffix = ""
		var reversed_tags = segment["tags"].duplicate()
		reversed_tags.reverse()
		for tag in reversed_tags:
			var tag_name = tag.split("=")[0]
			tag_suffix += "[/" + tag_name + "]"
		
		var segment_text = segment["text"]
		var add_text = ""
		
		if remaining >= segment_text.length():
			add_text = segment_text
			remaining -= segment_text.length()
		else:
			add_text = segment_text.substr(0, remaining)
			remaining = 0
		
		typed_bbcode += tag_prefix + add_text + tag_suffix
		if remaining <= 0:
			break
	
	dialogue_label.text = typed_bbcode


func _process(delta):
	if is_typing:
		typing_timer += delta
		if typing_timer >= typing_speed:
			typing_timer = 0.0
			visible_char_count += 1
			update_typed_text()
			
			# Check if fully typed
			var total_visible_chars = 0
			for segment in parsed_segments:
				total_visible_chars += segment["text"].length()
			if visible_char_count >= total_visible_chars:
				is_typing = false

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Ignore clicks if in animation
		if is_in_animation:
			return
		
		# Hide pop up if visible and progressing text
		if hint_popup.visible:
			hide_hint_popup()
			return
		# Skip text typing or go to next line
		if is_typing:
			# Fast-forward to full text
			is_typing = false
			dialogue_label.text = full_text
		else:
			# Advance to next line
			current_index += 1
			_show_next_line()

func show_hint_popup(word: String):
	var popup_position = get_viewport().get_mouse_position() + Vector2(0,-80)
	var hint_text = get_hint_text(word)
	hint_popup.show_hint(hint_text, popup_position)
func hide_hint_popup():
	hint_popup.hide_hint()
func get_hint_text(word: String) -> String:
	return hint_dict.get(word, "(No hint found)")
func compare_hints(new_word: String):
	var hint_new = get_hint_text(new_word)
	var hint_old = hint_popup.label.text
	
	if hint_new == hint_old:
		return true
	else:
		return false


func _on_meta_clicked(meta):
	if meta is String:
		var key = meta.replace("hint:", "")
		if compare_hints(key) and hint_popup.visible:
			return
		show_hint_popup(key)
func _on_dialogue_text_meta_hover_started(_meta: Variant) -> void:
	is_hovering_meta = true
func _on_dialogue_text_meta_hover_ended(_meta: Variant) -> void:
	is_hovering_meta = false


### Button Functions ###
func on_back_pressed():
	# If currently typing, show full line instead of jumping back
	if is_typing:
		is_typing = false
		dialogue_label.text = full_text
		return
		
	# Can't go back if already at first line
	if current_index <= 0:
		return
		
	current_index -= 1
	_show_next_line()

func on_next_pressed():
	# If still typing, skip to full line
	if is_typing:
		is_typing = false
		dialogue_label.text = full_text
		return
		
	# If hint is open, close it instead of progressing
	if hint_popup.visible:
		hide_hint_popup()
		return
		
	# Go to next line if available
	current_index += 1
	_show_next_line()

func _on_journal_button_pressed() -> void:
	DialogueManager.open_journal_menu()


### Animation Controls ###
func play_fade_in():
	is_in_animation = true
	SceneManager.in_dialogue = true
	anim_player.play("fade_in")
	await anim_player.animation_finished
	is_in_animation = false

func play_fade_out():
	is_in_animation = true
	anim_player.play("fade_out")
	SceneManager.in_dialogue = false
	await anim_player.animation_finished
	is_in_animation = false
	queue_free()
