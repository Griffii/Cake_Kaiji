extends Control

@onready var grandma_dialogue = "res://data/dialogue_trees/kiyomi_dialogue.json"


func _on_grandma_pressed():
	SceneManager.play_click_sfx()
	DialogueManager.start_dialogue(grandma_dialogue, "question")
