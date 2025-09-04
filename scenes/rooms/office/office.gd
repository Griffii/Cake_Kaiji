extends Control

@onready var dad_dialogue = "res://data/dialogue_trees/ken_dialogue.json"


func _on_dad_pressed():
	SceneManager.play_click_sfx()
	DialogueManager.start_dialogue(dad_dialogue, "question")

func reveal_dad_hints():
	SceneManager.play_click_sfx()
	CharacterData.set_flag("Ken/secret_info/sosuke_has_secret_hints", true)
