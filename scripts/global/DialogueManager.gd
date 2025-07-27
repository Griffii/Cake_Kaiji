# GlobalDialogue.gd
extends Node

func start_dialogue(dialogue_tree: String, dialogue_id: String):
	var dbox = preload("res://scenes/ui/DialogueBox.tscn").instantiate()
	get_tree().root.add_child(dbox)
	dbox.start_dialogue(dialogue_tree, dialogue_id)

func open_journal_menu():
	var journal_scene = preload("res://scenes/ui/Journal.tscn")
	var journal_instance = journal_scene.instantiate()
	get_tree().get_root().add_child(journal_instance)
	SceneManager.in_menu = true

func open_choice_menu(character_name: String):
	var choice_menu_scene = preload("res://scenes/ui/choice_menu.tscn").instantiate()
	get_tree().root.add_child(choice_menu_scene)
	choice_menu_scene.open_choice_menu(character_name)

### List of Custom Signals triggered during Dialogue
#signal screen_shake
