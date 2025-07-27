extends Control

@onready var grandma_dialogue_tree = "res://data/dialogue_trees/living_room_kiyomi.json"


func _ready() -> void:
	pass



func _on_grandma_pressed() -> void:
	DialogueManager.start_dialogue(grandma_dialogue_tree, "question_grandma")
