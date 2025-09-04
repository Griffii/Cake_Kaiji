extends CanvasLayer

@onready var main_choices = $Panel/MarginContainer/MainChoices
@onready var sub_choices = $Panel/MarginContainer/SubChoices
@onready var quit_button = $Panel/QuitButton
@onready var back_button = $Panel/BackButton
@onready var anim_player = $AnimationPlayer

@onready var option_button = preload("res://scenes/ui/buttons/options_button.tscn")

var character_dialogue_tree   # Path to charcters dialogue tree json
var current_npc_name = ""     # Set this when opening menu for a character
var secret_flag_path: String
var hints_flag_path: String
var secret_btn_disabled: bool

var _current_submenu_callback
var current_sub_menu_buttons: Array

func _ready():
	# Connect main choice buttons to functions
	%Btn_Where.pressed.connect(Callable(self, "_on_choice_where_pressed"))
	%Btn_Doing.pressed.connect(Callable(self, "_on_choice_doing_pressed"))
	%Btn_Cake.pressed.connect(Callable(self, "_on_choice_cake_pressed"))
	%Btn_Secret.pressed.connect(Callable(self, "_on_choice_secret_pressed"))
	back_button.pressed.connect(Callable(self, "_on_back_pressed"))
	quit_button.pressed.connect(Callable(self, "_on_quit_btn_pressed"))

func check_secret_button_status():
	if CharacterData.get_flag(hints_flag_path):
		if CharacterData.get_flag(secret_flag_path):
			secret_btn_disabled = true
		secret_btn_disabled = false
	else:
		secret_btn_disabled = true
	%Btn_Secret.disabled = secret_btn_disabled

### OPEN THE MENU ###
func open_choice_menu(character_name: String):
	SceneManager.in_menu = true
	SceneManager.in_choice_menu = true
	current_npc_name = character_name
	
	# Load characters dialogue tree file
	character_dialogue_tree = "res://data/dialogue_trees/%s_dialogue.json" % current_npc_name
	
	check_secret()
	
	anim_player.play("panel_in")
	quit_button.anim_player.play("appear")
	main_buttons_in()

func main_buttons_in():
	for btn in main_choices.get_children():
		btn.anim_player.play("appear")
		btn.disabled = false
	
	check_secret_button_status()
	_refresh_main_buttons()
	
	await _wait_for_buttons_to_finish(main_choices.get_children())

func main_buttons_out():
	for btn in main_choices.get_children():
		btn.disabled = true
		btn.anim_player.play("disappear")
	await _wait_for_buttons_to_finish(main_choices.get_children())



### BTN FUNCTIONS ###
func _on_choice_where_pressed():
	SceneManager.play_click_sfx()
	_show_sub_menu(["Morning", "Afternoon", "Evening"], "_on_time_selected")

func _on_choice_doing_pressed():
	SceneManager.play_click_sfx()
	var places = _get_known_places_for_character()
	if places.size() == 0:
		places = []
	_show_sub_menu(places, "_on_place_selected")

func _on_choice_cake_pressed():
	SceneManager.play_click_sfx()
	check_secret()
	
	if CharacterData.get_flag(secret_flag_path):
		DialogueManager.start_dialogue(character_dialogue_tree, "cake_truth")
	else:
		DialogueManager.start_dialogue(character_dialogue_tree, "cake_lie")
	
	_refresh_main_buttons()

func _on_choice_secret_pressed():
	SceneManager.play_click_sfx()
	# Launch mini-game or wahtever
	DialogueManager.start_dialogue(character_dialogue_tree, "reveal_secret")
	
	_refresh_main_buttons()

func _refresh_main_buttons():
	# Timeout to give the previous func time to update variables
	await get_tree().create_timer(0.5).timeout
	
	for btn in main_choices.get_children():
		if not btn is Button:
			continue
		
		match btn.name:
			"Btn_Cake":
				var key = ""
				if CharacterData.get_flag(secret_flag_path):
					key = "%s.cake_truth" % current_npc_name
				else:
					key = "%s.cake_lie" % current_npc_name
				
				if GameFlags.viewed_dialogues.has(key):
					btn.modulate = Color(0.5, 0.5, 0.5) # Dim
				else:
					btn.modulate = Color(1, 1, 1)
			
			"Btn_Secret":
				var key = "%s.reveal_secret" % current_npc_name
				if GameFlags.viewed_dialogues.has(key):
					btn.modulate = Color(0.5, 0.5, 0.5)
				else:
					btn.modulate = Color(1, 1, 1)



### SUB MENU FUNCTIONS ###
func _show_sub_menu(options: Array, callback: String):
	quit_button.anim_player.play("disappear")
	await main_buttons_out()
	await get_tree().create_timer(0.3).timeout
	
	current_sub_menu_buttons = options
	
	for option in options:
		var btn = option_button.instantiate()
		btn.visible = true
		btn.scale = Vector2.ZERO
		btn.text = option
		
		# Compute base key
		var base_key = ""
		if callback == "_on_time_selected":
			base_key = option.to_lower() + "_place"
		elif callback == "_on_place_selected":
			base_key = option.replace(" ", "_").to_lower() + "_activity"
		
		var target_key = ""
		
		if callback == "_on_time_selected":
			# Determine time key for the schedule
			var time_key = option.to_lower() # "morning", "afternoon", "evening"
			var lie_flag_path = "%s/schedule/%s/has_place_lie" % [current_npc_name, time_key]
			
			if CharacterData.get_flag(secret_flag_path):
				target_key = base_key + "_truth"
			else:
				# Check if a lie version exists for this time
				if CharacterData.get_flag(lie_flag_path):
					target_key = base_key + "_lie"
				else:
					target_key = base_key + "_truth"
		else:
			# Activity logic stays the same (activities always have lie & truth)
			if CharacterData.get_flag(secret_flag_path):
				target_key = base_key + "_truth"
			else:
				target_key = base_key + "_lie"
		
		
		# Build unique ID
		var unique_id = "%s.%s" % [current_npc_name, target_key]
		
		# Check viewed status only for the relevant version
		var viewed = GameFlags.viewed_dialogues.has(unique_id)
		
		# Apply fade if viewed
		if viewed:
			btn.modulate = Color(0.5, 0.5, 0.5) # Dim button
		else:
			btn.modulate = Color(1, 1, 1)
		
		sub_choices.add_child(btn)
		btn.pressed.connect(Callable(self, callback).bind(option))
	
	back_button.anim_player.play("appear")
	for child in sub_choices.get_children():
		child.anim_player.play("appear")

func _on_time_selected(time: String):
	SceneManager.play_click_sfx()
	_current_submenu_callback = "_on_time_selected"
	check_secret()
	
	match time:
		"Morning":
			var morning_lie_path = "%s/schedule/morning/has_place_lie" % current_npc_name
			if CharacterData.get_flag(morning_lie_path) and !CharacterData.get_flag(secret_flag_path):
				DialogueManager.start_dialogue(character_dialogue_tree, "morning_place_lie")
			else:
				DialogueManager.start_dialogue(character_dialogue_tree, "morning_place_truth")
		"Afternoon":
			var afternoon_lie_path = "%s/schedule/afternoon/has_place_lie" % current_npc_name
			if CharacterData.get_flag(afternoon_lie_path) and !CharacterData.get_flag(secret_flag_path):
				DialogueManager.start_dialogue(character_dialogue_tree, "afternoon_place_lie")
			else:
				DialogueManager.start_dialogue(character_dialogue_tree, "afternoon_place_truth")
		"Evening":
			var evening_lie_path = "%s/schedule/evening/has_place_lie" % current_npc_name
			if CharacterData.get_flag(evening_lie_path) and !CharacterData.get_flag(secret_flag_path):
				DialogueManager.start_dialogue(character_dialogue_tree, "evening_place_lie")
			else:
				DialogueManager.start_dialogue(character_dialogue_tree, "evening_place_truth")
	
	refresh_subchoice_buttons()

func _on_place_selected(place: String):
	SceneManager.play_click_sfx()
	_current_submenu_callback = "_on_place_selected"
	check_secret()
	
	if place == "(No places known)":
		return
	
	place = place.replace(" ", "_").to_lower()
	print("Selected place: ", place)
	
	var dialogue_path: String 
	
	if !CharacterData.get_flag(secret_flag_path):
		dialogue_path = place + "_activity_lie"
	else:
		dialogue_path = place + "_activity_truth"
	
	DialogueManager.start_dialogue(character_dialogue_tree, dialogue_path)
	
	refresh_subchoice_buttons()

func refresh_subchoice_buttons():
	# Timeout to give the previous func time to update variables
	await get_tree().create_timer(1.0).timeout
	
	for btn in sub_choices.get_children():
		if not btn is Button:
			continue
		
		var option_text = btn.text
		var base_key = ""
		
		# Determine if this button belongs to time menu or place menu
		if _current_submenu_callback == "_on_time_selected":
			base_key = option_text.to_lower() + "_place"
		elif _current_submenu_callback == "_on_place_selected":
			base_key = option_text.replace(" ", "_").to_lower() + "_activity"
		else:
			continue  # Skip if not recognized
		
		# Determine which version should count as viewed
		var target_key = ""
		
		if _current_submenu_callback == "_on_time_selected":
			var time_key = option_text.to_lower() # morning / afternoon / evening
			var lie_flag_path = "%s/schedule/%s/has_place_lie" % [current_npc_name, time_key]
			
			if CharacterData.get_flag(secret_flag_path):
				target_key = base_key + "_truth"
			else:
				# If lie exists, check lie, otherwise truth
				if CharacterData.get_flag(lie_flag_path):
					target_key = base_key + "_lie"
				else:
					target_key = base_key + "_truth"
		else:
			# Activities always have truth & lie
			if CharacterData.get_flag(secret_flag_path):
				target_key = base_key + "_truth"
			else:
				target_key = base_key + "_lie"
		
		var unique_id = "%s.%s" % [current_npc_name, target_key]
		
		# Apply dimming
		if GameFlags.viewed_dialogues.has(unique_id):
			btn.modulate = Color(0.5, 0.5, 0.5) # Dim
		else:
			btn.modulate = Color(1, 1, 1)       # Normal



### SUPPORT FUNCTIONS ###
func check_secret():
	# Enable or disable "I know your secret!"
	secret_flag_path = "%s/secret_info/sosuke_knows_secret" % current_npc_name
	hints_flag_path = "%s/secret_info/sosuke_has_secret_hints" % current_npc_name

func _wait_for_buttons_to_finish(buttons: Array) -> void:
	var signals = []
	for btn in buttons:
		signals.append(btn.anim_player.animation_finished)
	for i in signals:
		await i

func _on_back_pressed():
	back_button.anim_player.play("disappear")
	
	# Clear buttons
	for child in sub_choices.get_children():
		child.clear_button()
	await get_tree().create_timer(0.4).timeout
	
	current_sub_menu_buttons = []
	
	quit_button.anim_player.play("appear")
	main_buttons_in()

func _get_known_places_for_character() -> Array:
	var places = []
	if current_npc_name == "":
		return places
	var char_schedule = CharacterData.characters[current_npc_name]["schedule"]
	for time_key in char_schedule.keys():
		var guess = char_schedule[time_key].get("sosuke_thinks_place", "")
		if guess != "" and not places.has(guess) and guess != "???":
			places.append(guess)
	return places

func _on_quit_btn_pressed():
	anim_player.play("panel_out")
	quit_button.anim_player.play("disappear")
	await anim_player.animation_finished
	SceneManager.in_menu = false
	SceneManager.in_choice_menu = false
	# Close the dialogue menu before saying night night
	DialogueManager.end_diaolgue()
	queue_free()
