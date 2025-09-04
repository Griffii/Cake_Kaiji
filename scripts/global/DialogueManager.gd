extends Node

## Sosukes global Dialogue tree access ################
@onready var sosuke_dialogue = "res://data/dialogue_trees/sosuke_dialogue.json"
@onready var mom_dialogue = "res://data/dialogue_trees/karin_dialogue.json"
@onready var yuka_dialogue = "res://data/dialogue_trees/yuka_dialogue.json"
@onready var grandpa_dialogue = "res://data/dialogue_trees/ichiro_dialogue.json"
@onready var grandma_dialogue = "res://data/dialogue_trees/kiyomi_dialogue.json"
@onready var dad_dialogue = "res://data/dialogue_trees/ken_dialogue.json"





func start_dialogue(dialogue_tree: String, dialogue_id: String):
	# Delete dialogue box if it already exists
	await end_diaolgue()
	# Create new dbox scene
	var dbox = preload("res://scenes/ui/DialogueBox.tscn").instantiate()
	dbox.name = "DialogueBox"
	get_tree().root.add_child(dbox)
	dbox.start_dialogue(dialogue_tree, dialogue_id)
	
	# Add dialogue to viewed list in GameFlags
	var unique_id = "%s.%s" % [dialogue_tree.get_file().replace("_dialogue.json", ""), dialogue_id]
	GameFlags.viewed_dialogues[unique_id] = true

func end_diaolgue():
	if get_tree().root.has_node("DialogueBox"):
		var old_box = get_tree().root.get_node("DialogueBox")
		await old_box.end_dialogue()
		await old_box.tree_exited


func open_choice_menu(character_name: String):
	var choice_menu_scene = preload("res://scenes/ui/choice_menu.tscn").instantiate()
	get_tree().root.add_child(choice_menu_scene)
	choice_menu_scene.open_choice_menu(character_name)


### List of Custom Signals triggered during Dialogue
#signal screen_shake
