extends CanvasLayer

@onready var main_choices = $Panel/MarginContainer/MainChoices
@onready var sub_choices = $Panel/MarginContainer/SubChoices
@onready var quit_button = $Panel/QuitButton
@onready var back_button = $Panel/BackButton
@onready var anim_player = $AnimationPlayer

@onready var option_button = preload("res://scenes/ui/buttons/options_button.tscn")

var current_npc_name = ""  # Set this when opening menu for a character

func _ready():
	# Enable or disable "I know your secret!"
	var secret_flag_path = "%s/secret_info/sosuke_knows_secret" % current_npc_name
	%Btn_Secret.disabled = not CharacterData.get_flag(secret_flag_path)
	
	# Connect main choice buttons to functions
	%Btn_Where.pressed.connect(Callable(self, "_on_choice_where_pressed"))
	%Btn_Doing.pressed.connect(Callable(self, "_on_choice_doing_pressed"))
	%Btn_Cake.pressed.connect(Callable(self, "_on_choice_cake_pressed"))
	%Btn_Secret.pressed.connect(Callable(self, "_on_choice_secret_pressed"))
	back_button.pressed.connect(Callable(self, "_on_back_pressed"))
	quit_button.pressed.connect(Callable(self, "_on_quit_btn_pressed"))


### OPEN THE MENU ###
func open_choice_menu(character_name: String):
	SceneManager.in_menu = true
	current_npc_name = character_name
	
	main_choices.visible = true
	sub_choices.visible = false
	back_button.visible = false
	visible = true # Replace with animation
	anim_player.play("panel_in")
	
	quit_button.anim_player.play("appear")
	main_buttons_in()

func main_buttons_in():
	%Btn_Where.anim_player.play("appear")
	%Btn_Doing.anim_player.play("appear")
	%Btn_Cake.anim_player.play("appear")
	%Btn_Secret.anim_player.play("appear")

func main_buttons_out():
	%Btn_Where.anim_player.play("disappear")
	%Btn_Doing.anim_player.play("disappear")
	%Btn_Cake.anim_player.play("disappear")
	%Btn_Secret.anim_player.play("disappear")

### BTN FUNCTIONS ###
func _on_choice_where_pressed():
	_show_sub_menu(["Morning", "Afternoon", "Evening"], "_on_time_selected")

func _on_choice_doing_pressed():
	var places = _get_known_places_for_character()
	if places.size() == 0:
		places = ["(No places known)"]
	_show_sub_menu(places, "_on_place_selected")

func _on_choice_cake_pressed():
	# Trigger cake question dialogue
	#DialogueManager.start_dialogue(dialogue_tree, dialogue_name)
	pass

func _on_choice_secret_pressed():
	# Launch mini-game
	pass


### SUB MENU FUNCTIONS ###
func _show_sub_menu(options: Array, callback: String):
	quit_button.anim_player.play("disappear")
	main_buttons_out()
	await quit_button.anim_player.animation_finished
	main_choices.visible = false
	
	back_button.visible = true
	back_button.anim_player.play("appear")
	
	# Clear old buttons
	for child in sub_choices.get_children():
		child.queue_free()
	sub_choices.visible = true
	
	# Add new buttons
	for option in options:
		var btn = option_button.instantiate() # For PackedScene
		btn.text = option
		btn.pressed.connect(Callable(self, callback).bind(option))
		sub_choices.add_child(btn)
	
	# Call animations for each button
	for child in sub_choices.get_children():
		child.anim_player.play("appear")
		#await get_tree().create_timer(0.2).timeout # Offset the button spawns slightly

func _on_time_selected(time: String):
	print("Time selected: ", time)

func _on_place_selected(place: String):
	if place == "(No places known)":
		return
	print("Selected place: ", place)


### SUPPORT FUNCTIONS ###
func _on_back_pressed():
	back_button.anim_player.play("disappear")
	
	# Clear buttons
	for child in sub_choices.get_children():
		child.clear_button()
	await get_tree().create_timer(0.4).timeout
	
	sub_choices.visible = false
	main_choices.visible = true
	
	quit_button.anim_player.play("appear")
	main_buttons_in()

func _get_known_places_for_character() -> Array:
	var places = []
	if current_npc_name == "":
		return places
	var char_schedule = CharacterData.characters[current_npc_name]["schedule"]
	for time_key in char_schedule.keys():
		var guess = char_schedule[time_key].get("sosuke_thinks_place", "")
		if guess != "" and not places.has(guess):
			places.append(guess)
	return places

func _on_quit_btn_pressed():
	anim_player.play("panel_out")
	quit_button.anim_player.play("disappear")
	await anim_player.animation_finished
	SceneManager.in_menu = false
	queue_free()
