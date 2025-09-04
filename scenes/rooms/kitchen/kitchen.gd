extends Control

@onready var mom_dialogue_tree = "res://data/dialogue_trees/karin_dialogue.json"

@onready var mom = %Mom



func _on_mom_pressed():
	SceneManager.play_click_sfx()
	DialogueManager.start_dialogue(mom_dialogue_tree, "question")
	


func _on_button_pressed() -> void:
	SceneManager.play_click_sfx()
	CharacterData.set_flag("Karin/secret_info/sosuke_has_secret_hints", true)
