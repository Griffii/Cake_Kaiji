extends CanvasLayer

@onready var name_label = %NameLabel
@onready var portrait_sprite = %Portrait
@onready var dialogue_label = %DialogueText
@onready var hint_popup: Control = $HintPopup
@onready var anim_player = $AnimationPlayer
@onready var typing_sfx = $TypingSFX

var dialogue_data = {}         # Stores loaded JSON dialogue
var current_lines = []         # Current dialogue lines
var current_index = 0
var is_typing = false
var is_in_dialogue = false
var char_index = 0
var text_speed = 0.03          # Default speed (seconds per character)
var current_text = ""
var type_timer: Timer
var parsed_segments = []       # For BBCode parsing
var visible_char_count = 0
var full_text = ""
var hint_dict = {}             # Stores current dialogue dictionary for hints
var line_actions               # Stores signals from dialogue

var is_hovering_meta = false
var is_in_animation = false

# Character registry reference
var character_data

func _ready():
	character_data = CharacterData.characters
	type_timer = Timer.new()
	type_timer.one_shot = false
	type_timer.wait_time = text_speed
	type_timer.timeout.connect(_on_type_timer_timeout)
	add_child(type_timer)


### INPUT HANDLING ###
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if SceneManager.in_dialogue and !SceneManager.in_menu:
			on_next_pressed()


### LOAD AND START DIALOGUE ###
func load_dialogue_data(dialogue_tree: String):
	var file_path = dialogue_tree
	if not file_path.begins_with("res://"):
		file_path = "res://" + file_path

	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		dialogue_data = JSON.parse_string(file.get_as_text())
		file.close()
	else:
		push_error("Dialogue JSON not found: " + file_path)

func start_dialogue(dialogue_tree: String, dialogue_id: String):
	load_dialogue_data(dialogue_tree)
	
	if dialogue_id in dialogue_data:
		var dialogue_block = dialogue_data[dialogue_id]
		current_lines = dialogue_block.get("lines", [])
		hint_dict = dialogue_block.get("dictionary", {})   # Load dictionary for hints
		current_index = 0
		
		# Wipe defualt dialogue text
		dialogue_label.text = ""
		# Get speaker info from dialogue tree
		var line = current_lines[current_index]
		var speaker = line.get("speaker", "")
		var emotion = line.get("emotion", "default")
		# Get speaker info from CharacterData
		var char_info = character_data[speaker]
		var portraits = char_info.get("portraits", {})
		var bg_color = char_info.get("bg_color_code", "")
		# Set speaker name and portrait before load in
		name_label.text = char_info.get("character_name", speaker)
		name_label.get_theme_stylebox("normal").bg_color = Color(bg_color)
		portrait_sprite.texture = portraits.get(emotion, portraits.get("default", null))
		
		play_fade_in()
		await get_tree().create_timer(1).timeout
		
		show_line(current_index)
	else:
		push_error("Dialogue ID not found: " + dialogue_id)


### SHOW LINE ###
func show_line(index: int):
	if index >= current_lines.size():
		end_dialogue()
		return
		
	var line = current_lines[index]
	var speaker = line.get("speaker", "")
	var emotion = line.get("emotion", "default")
	var actions = line.get("actions", [])
	full_text = line.get("text", "")
	
	# Convert speed to delay
	if line.has("speed"):
		text_speed = 1.0 / float(line["speed"])
	else:
		text_speed = 0.03
	
	# Update name & portrait
	if character_data.has(speaker):
		var char_info = character_data[speaker]
		name_label.text = char_info.get("character_name", speaker)
		name_label.get_theme_stylebox("normal").bg_color = Color(char_info.get("bg_color_code", ""))
		var portraits = char_info.get("portraits", {})
		portrait_sprite.texture = portraits.get(emotion, portraits.get("default", null))
	else:
		name_label.text = ""
		portrait_sprite.texture = null
	
	# Reset text
	dialogue_label.bbcode_enabled = true
	parse_bbcode_segments(full_text)
	dialogue_label.text = ""
	char_index = 0
	visible_char_count = 0
	is_typing = true
	typing_sfx.play()
	
	type_timer.wait_time = text_speed
	type_timer.start()
	
	# Store actions to trigger later - Sounds / Aniamtions / Etc
	line_actions = actions


### TYPEWRITER EFFECT ###
func _on_type_timer_timeout():
	if visible_char_count < get_total_text_length():
		visible_char_count += 1
		update_typed_text()
	else:
		is_typing = false
		type_timer.stop()
		typing_sfx.stop()
	
	# Do actions when typing is finished
	do_actions()

## ACTIONS AND SIGNALS ###
func do_actions():
	if !is_typing:
		# Execute stored actions
		for action in line_actions:
			match action.get("type", ""):
				"sound":
					var audio_path = "res://assets/audio/sfx/"
					audio_path += (action["value"])
					var audio = AudioStreamPlayer.new()
					audio.stream = load(audio_path)
					add_child(audio)
					audio.play()
				
				"knowledge_update":
					var character = action.get("character", "")
					var flag = action.get("flag", "")
					var value = action.get("value", false)
					if CharacterData.characters.has(character):
						CharacterData.characters[character][flag] = value
				
				"signal":
					var sig = action["value"]
					if DialogueManager.has_signal(sig):
						DialogueManager.emit_signal(sig)
				
				"change_scene":
					var scene_path = action.get("value", "")
					SceneManager.change_scene(scene_path)
				
				"open_choice_menu":
					var character_name = action.get("value", "")
					DialogueManager.open_choice_menu(character_name)


### BBCode Parsing ###
func parse_bbcode_segments(text: String):
	parsed_segments.clear()
	var tag_stack: Array = []
	var i = 0
	var current_text = ""
	
	while i < text.length():
		if text[i] == "[":
			if current_text != "":
				parsed_segments.append({"text": current_text, "tags": tag_stack.duplicate()})
				current_text = ""
			
			var end = text.find("]", i)
			if end == -1:
				break
			var tag = text.substr(i + 1, end - i - 1)
			
			if tag.begins_with("/"):
				if tag_stack.size() > 0:
					tag_stack.pop_back()
			else:
				tag_stack.append(tag)
			i = end + 1
		else:
			current_text += text[i]
			i += 1
	
	if current_text != "":
		parsed_segments.append({"text": current_text, "tags": tag_stack.duplicate()})

func get_total_text_length() -> int:
	var total = 0
	for seg in parsed_segments:
		total += seg["text"].length()
	return total

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


### HINT FUNCTIONS ###
func show_hint_popup(word: String):
	var popup_position = get_viewport().get_mouse_position() + Vector2(0, -80)
	var hint_text = get_hint_text(word)
	hint_popup.show_hint(hint_text, popup_position)

func hide_hint_popup():
	hint_popup.hide_hint()

func get_hint_text(word: String) -> String:
	return hint_dict.get(word, "(No hint found)")

func compare_hints(new_word: String) -> bool:
	var hint_new = get_hint_text(new_word)
	var hint_old = hint_popup.label.text
	return hint_new == hint_old


### META HANDLERS ###
func _on_meta_clicked(meta):
	if meta is String:
		if meta.begins_with("hint:"):
			var key = meta.replace("hint:", "")
			if compare_hints(key) and hint_popup.visible:
				return
			show_hint_popup(key)

func _on_dialogue_text_meta_hover_started(_meta: Variant) -> void:
	is_hovering_meta = true

func _on_dialogue_text_meta_hover_ended(_meta: Variant) -> void:
	is_hovering_meta = false



### BUTTON FUNCTIONS ###
func on_back_pressed():
	# If currently typing, finish current line
	if is_typing:
		is_typing = false
		visible_char_count = get_total_text_length()
		update_typed_text()
		return
	
	# Prevent going before first line
	if current_index <= 0:
		return
	
	current_index -= 1
	show_line(current_index)

func on_next_pressed():
	if is_in_animation:
		return
	else:
		# If still typing, show full text immediately
		if is_typing:
			is_typing = false
			visible_char_count = get_total_text_length()
			update_typed_text()
			return
		
		# If hint popup is open, close it instead of progressing
		if hint_popup.visible:
			hide_hint_popup()
			return
		
		# Go to next line if available
		current_index += 1
		show_line(current_index)



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


func end_dialogue():
	play_fade_out()
	current_lines.clear()
	current_index = 0
	await anim_player.animation_finished
	await get_tree().create_timer(0.5).timeout
	queue_free()
