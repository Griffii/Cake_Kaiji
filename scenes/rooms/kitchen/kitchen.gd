extends Control

@onready var dialogue_tree_intro = "res://data/dialogue_trees/kitchen_dialogue.json"

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout # Half second pause to wait for scene transition
	DialogueManager.start_dialogue(dialogue_tree_intro, "test_full_features")
