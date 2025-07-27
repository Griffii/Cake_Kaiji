extends Control

@onready var yukas_dialogue_tree = "res://data/dialogue_trees/yukas_dialogue.json"



func _ready() -> void:
	
	await get_tree().create_timer(0.5).timeout # Half second pause to wait for scene transition
	
	# If Sosuke has been kicked out, kick him out again immediately
	if GameFlags.get_flag("rooms/yukas_room/kicked_out"):
		DialogueManager.start_dialogue(yukas_dialogue_tree, "yuka_room_visit")



func _on_yuka_pressed() -> void:
	if !GameFlags.get_flag("rooms/yukas_room/kicked_out"):
		DialogueManager.start_dialogue(yukas_dialogue_tree, "yuka_room_first_visit")
		GameFlags.set_flag("rooms/yukas_room/kicked_out", true)
