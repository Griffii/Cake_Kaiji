extends CanvasLayer

@onready var name_label = %NameLabel
@onready var portrait_sprite = %Portrait
@onready var dialogue_container = %DialogueContainer
@onready var anim_player = $AnimationPlayer
@onready var typing_sfx = $TypingSFX

@export var dialogue_font: Font
@export var italic_font: Font
@export var bold_font: Font
@export var dialogue_font_size: int = 52

var dialogue_data = {}         # Stores loaded JSON dialogue
var current_lines = []         # Current dialogue lines
var current_index = 0
var char_index = 0
var text_speed = 0.05          # Default speed (seconds per character)
var type_timer: Timer
var visible_char_count = 0
var full_tokens = []           # Parsed tokens for current line
var token_index = 0            # Which token we're processing
var char_index_in_token = 0
var line_actions = []

var is_typing = false
var is_in_dialogue = false
var is_in_animation = false

# Character registry reference
var character_data

func _ready():
	character_data = CharacterData.characters
	type_timer = Timer.new()
	type_timer.one_shot = false
	type_timer.timeout.connect(_on_type_timer_timeout)
	add_child(type_timer)

func _process(_delta: float) -> void:
	# Toggle buttons based on current state
	if current_index == current_lines.size() - 1:
		if SceneManager.in_choice_menu:
			SceneManager.choice_menu_paused = false
			%NextButton.disabled = true
		else:
			# Dim, but dont disable
			%NextButton.modulate = Color(0.6, 0.6, 0.6, 1)  # Slight gray tone
	else:
		%NextButton.disabled = false
		%NextButton.modulate = Color(1,1,1,1)
	
	if current_index > 0:
		%BackButton.disabled = false
	else:
		%BackButton.disabled = true

### INPUT HANDLING ###
func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if SceneManager.in_dialogue:
			if !SceneManager.in_menu or SceneManager.in_choice_menu:
				on_next_pressed()


### LOAD AND START DIALOGUE ###
func load_dialogue_data(file_path: String):
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
		# If the dailogue tree exists, check if it was started while in the choice menu
		# If it was, "pause" the choice menu to allow dialogue traversal until the end of the dialogue tree
		if SceneManager.in_choice_menu:
			SceneManager.choice_menu_paused = true
		
		var dialogue_block = dialogue_data[dialogue_id]
		current_lines = dialogue_block.get("lines", [])
		current_index = 0
		
		# Prepare UI for fade-in
		name_label.text = ""
		portrait_sprite.texture = null
		
		# Set initial character info from first line
		var first_line = current_lines[0]
		_set_character_info(first_line)
		
		play_fade_in()
		await get_tree().create_timer(0.5).timeout
		show_line(current_index)
	else:
		push_error("Dialogue ID not found: " + dialogue_id)
		queue_free() # Kill yourself if there is no Dialogue to play


### SHOW LINE ###
func show_line(index: int):
	if index >= current_lines.size():
		end_dialogue()
		return
	
	# Reset typewriter FIRST
	type_timer.stop()
	visible_char_count = 0
	is_typing = false
	
	var line = current_lines[index]
	full_tokens = parse_text(line.get("text", ""))
	line_actions = line.get("actions", [])
	token_index = 0
	char_index_in_token = 0
	visible_char_count = 0
	
	
	# Set character info (name, portrait, bg)
	_set_character_info(line)
	
	# Clear previous dialogue nodes
	for child in dialogue_container.get_children():
		child.queue_free()
	
	# Create tokens as labels or vocab scenes
	for token in full_tokens:
		if token.has("type") and (token["type"] == "speed" or token["type"] == "pause"):
			# Handle during typewriter, not now
			continue
		if token.get("is_vocab", false):
			var vocab_instance = preload("res://scenes/ui/vocab.tscn").instantiate()
			dialogue_container.add_child(vocab_instance)
			vocab_instance.set_data(token["type"], token["eng"], token["jpn"])
		else:
			var lbl = Label.new()
			dialogue_container.add_child(lbl)
			
			lbl.text = token["text"]
			lbl.visible_characters = 0
			
			# Font style logic
			if token["is_bold"]:
				lbl.add_theme_font_override("font", bold_font)
			elif token["is_italic"]:
				lbl.add_theme_font_override("font", italic_font)
			else:
				lbl.add_theme_font_override("font", dialogue_font)
			
			lbl.add_theme_font_size_override("font_size", dialogue_font_size)
	
	# Now start typing fresh
	is_typing = true
	type_timer.wait_time = text_speed
	type_timer.start()



### TYPEWRITER EFFECT ###
func _on_type_timer_timeout():
	if token_index >= full_tokens.size():
		is_typing = false
		type_timer.stop()
		do_actions()
		return
	
	var token = full_tokens[token_index]
	
	# Handle special tokens
	if token.has("type"):
		match token["type"]:
			"speed":
				apply_speed(token["value"])
				token_index += 1
				return
			"pause":
				type_timer.stop()
				is_typing = false
				var delay = token["duration"]
				token_index += 1
				await get_tree().create_timer(delay).timeout
				type_timer.start()
				is_typing = true
				return
	
	# Handle text or vocab tokens
	var char_count = 0
	if token.get("is_vocab", false):
		char_count = token["eng"].length()
	else:
		char_count = token["text"].length()
	
	# Reveal characters gradually
	if char_index_in_token < char_count:
		visible_char_count += 1
		update_typed_text()
		char_index_in_token += 1
	else:
		# Finished this token, move to next
		token_index += 1
		char_index_in_token = 0

func update_typed_text():
	var remaining = visible_char_count
	
	for child in dialogue_container.get_children():
		if child.has_method("set_visible_chars") and !child.is_finished(): # vocab node
			var eng_len = child.eng_text.length()
			var new_visible = min(eng_len, remaining)
			
			# Only update if the new visible count is greater
			if new_visible > child.current_visible:
				child.set_visible_chars(new_visible)
				typing_sfx.play()
			remaining -= new_visible
		else: # normal label
			var text_len = child.text.length()
			var new_visible_text = min(text_len, remaining)
			
			if new_visible_text > child.visible_characters:
				child.visible_characters = new_visible_text
				typing_sfx.play()
			remaining -= new_visible_text
			
		if remaining <= 0:
			break

func check_special_tokens():
	for token in full_tokens:
		if token.has("type"):
			match token["type"]:
				"speed":
					apply_speed(token["value"])
					full_tokens.erase(token)
					return false # No pause, keep typing
				"pause":
					type_timer.stop()
					var delay = token["duration"]
					full_tokens.erase(token)
					await get_tree().create_timer(delay).timeout
					type_timer.start()
					return true # Pause applied
	return false

func apply_speed(speed: String):
	match speed:
		"slow": type_timer.wait_time = 0.10
		"fast": type_timer.wait_time = 0.02
		"normal": type_timer.wait_time = 0.05

func get_total_text_length() -> int:
	var length = 0
	for child in dialogue_container.get_children():
		# For vocab scene, use eng_text property
		if child.has_method("get_eng_text_length"):
			length += child.get_eng_text_length()
		elif child is Label:
			length += child.text.length()
	return length


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
					var flag_path = action.get("flag", "")
					var value = action.get("value", false)
					
					if CharacterData.characters.has(character):
						var current = CharacterData.characters[character]
						var keys = flag_path.split(".")
						
						# Traverse through nested keys
						for i in range(keys.size() - 1):
							if current.has(keys[i]):
								current = current[keys[i]]
							else:
								push_error("Invalid flag path: " + flag_path)
								return
						
						var last_key = keys[keys.size() - 1]
						if current.has(last_key):
							# Only update if value is different
							if current[last_key] != value:
								current[last_key] = value
								SceneManager.play_update_notebook()
								print("Knowledge Update: ", character, " - ", flag_path, " = ", value)
							else:
								print("Knowledge unchanged for ", character, " (", flag_path, ") → already ", str(value))
						else:
							push_error("Invalid final key in path: " + last_key)
				
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


### CHARACTER INFO ###
func _set_character_info(line: Dictionary):
	var speaker = line.get("speaker", "")
	var emotion = line.get("emotion", "default") # fallback to default
	
	if CharacterData.characters.has(speaker):
		var char_info = CharacterData.characters[speaker]
		var is_new_speaker : bool
		
		# If it's a different speaker, play the animation
		if name_label.text != char_info["character_name"]:
			is_new_speaker = true
		
		if is_new_speaker:
			anim_player.play("character_out")
		
		# Set name and background color
		name_label.text = char_info["character_name"]
		name_label.get_theme_stylebox("normal").bg_color = Color(char_info["bg_color_code"])
		
		# Get portrait by emotion
		var portraits = char_info.get("portraits", {})
		if portraits.has(emotion):
			portrait_sprite.texture = portraits[emotion]
		else:
			# fallback if the emotion doesn't exist
			print("Emotion not found, setting to 'default'.")
			portrait_sprite.texture = portraits.get("default", null)
		
		if is_new_speaker:
			anim_player.play("character_in")
	
	# Make dialogue box speaker info blank if no speaker is set
	else:
		portrait_sprite.texture = null
		name_label.text = ""


### Parsing ###
func parse_text(raw_text: String) -> Array:
	var tokens: Array = []
	var regex = RegEx.new()
	# Updated pattern to accept any word type (noun, verb, etc.) OR phrase
	regex.compile("\\[type:([^,]+),\\s*eng:([^,]+),\\s*jpn:([^\\]]+)\\]|\\[i\\](.*?)\\[/i\\]|\\[b\\](.*?)\\[/b\\]|\\[speed:(slow|fast|normal)\\]|\\[pause:([0-9\\.]+)\\]")
	
	var start = 0
	for match in regex.search_all(raw_text):
		if match.get_start() > start:
			tokens.append({
				"text": raw_text.substr(start, match.get_start() - start),
				"is_vocab": false,
				"is_italic": false,
				"is_bold": false
			})
		
		if match.get_string(1) != "":
			# Vocab token
			var vocab_type = match.get_string(1).strip_edges() # e.g., noun, verb, phrase
			var vocab_eng = match.get_string(2).strip_edges()
			var vocab_jpn = match.get_string(3).strip_edges()
			
			tokens.append({
				"text": vocab_eng,
				"is_vocab": true,
				"is_italic": false,
				"is_bold": false,
				"eng": vocab_eng,
				"jpn": vocab_jpn,
				"type": vocab_type
			})
		elif match.get_string(4) != "":
			# Italic text
			tokens.append({
				"text": match.get_string(4),
				"is_vocab": false,
				"is_italic": true,
				"is_bold": false
			})
		elif match.get_string(5) != "":
			# Bold text
			tokens.append({
				"text": match.get_string(5),
				"is_vocab": false,
				"is_italic": false,
				"is_bold": true
			})
		elif match.get_string(6) != "":
			# Speed change
			tokens.append({
				"type": "speed",
				"value": match.get_string(6)
			})
		elif match.get_string(7) != "":
			# Pause
			tokens.append({
				"type": "pause",
				"duration": float(match.get_string(7))
			})
		
		start = match.get_end()
	
	if start < raw_text.length():
		tokens.append({
			"text": raw_text.substr(start, raw_text.length() - start),
			"is_vocab": false,
			"is_italic": false,
			"is_bold": false
		})
	
	return tokens



### BUTTON FUNCTIONS ###
func on_next_pressed():
	await get_tree().process_frame
	
	if is_in_animation:
		return
	
	# If typing → finish the current line instantly
	if is_typing:
		is_typing = false
		visible_char_count = get_total_text_length()
		update_typed_text()
		type_timer.stop()
		do_actions()
		
		# Force vocab reveal
		for child in dialogue_container.get_children():
			if child.has_method("force_full_reveal"):
				child.force_full_reveal()
		
		return
	
	# Block if choice menu is active and NOT paused
	if SceneManager.in_choice_menu and !SceneManager.choice_menu_paused:
		return
	
	
	
	
	# Otherwise, move forward
	current_index += 1
	show_line(current_index)

func on_back_pressed():
	await get_tree().process_frame
	
	%NextButton.disabled = false
	
	# Allow re-pausing and backward movement
	if SceneManager.in_choice_menu and !SceneManager.choice_menu_paused:
		SceneManager.choice_menu_paused = true
	if current_index > 0:
		current_index -= 1
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
	await anim_player.animation_finished
	queue_free()
