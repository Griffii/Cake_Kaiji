extends Control

@onready var grandma_dialogue_tree = "res://data/dialogue_trees/kiyomi_dialogue.json"


func _ready() -> void:
	pass



func _on_grandma_pressed() -> void:
	SceneManager.play_click_sfx()
	DialogueManager.start_dialogue(grandma_dialogue_tree, "question")


func _on_button_pressed() -> void:
	CharacterData.set_flag("Kiyomi/secret_info/sosuke_knows_secret", true)
	SceneManager.play_click_sfx()
	print("Grandma is feeling honest now.")
