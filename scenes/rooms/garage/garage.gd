extends Control

@onready var grandpa_dialogue = "res://data/dialogue_trees/ichiro_dialogue.json"


func _on_note_pressed() -> void:
	SceneManager.play_click_sfx()
	CharacterData.set_flag("Yuka/secret_info/hint_2", true)
	CharacterData.check_if_all_hints("Yuka")
	print("You found a hint about Yuka!")


func _on_grandpa_pressed():
	SceneManager.play_click_sfx()
	DialogueManager.start_dialogue(grandpa_dialogue, "question")
