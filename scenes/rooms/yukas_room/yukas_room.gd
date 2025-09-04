extends Control

@onready var yukas_dialogue_tree = "res://data/dialogue_trees/yuka_dialogue.json"



func _ready() -> void:
	
	await get_tree().create_timer(0.5).timeout # Half second pause to wait for scene transition
	
	# If Sosuke has secret hints - open choice_menu (Should start mini game really)
	if CharacterData.get_flag("Yuka/secret_info/sosuke_has_secret_hints"):
		DialogueManager.start_dialogue(yukas_dialogue_tree, "yuka_room_visit_has_secret_hints")
	
	# If Sosuke has been kicked out, kick him out again immediately
	elif GameFlags.get_flag("rooms/yukas_room/kicked_out"):
		DialogueManager.start_dialogue(yukas_dialogue_tree, "yuka_room_kicked_out")



func _on_yuka_pressed() -> void:
	if !GameFlags.get_flag("rooms/yukas_room/kicked_out"):
		DialogueManager.start_dialogue(yukas_dialogue_tree, "yuka_room_first_visit")
		GameFlags.set_flag("rooms/yukas_room/kicked_out", true)


## ------- HINT ITEM BUTTONS -----------------------------
func _on_jacket_pressed():
	SceneManager.play_click_sfx()
	
	DialogueManager.start_dialogue(yukas_dialogue_tree, "jacket_found")
	
	# Redundant value change, just in case
	CharacterData.set_flag("Yuka/secret_info/hint_1", true)
	CharacterData.check_if_all_hints("Yuka")
	print("You found a hint about Yuka!")


func _on_box_pressed():
	SceneManager.play_click_sfx()
	
	DialogueManager.start_dialogue(yukas_dialogue_tree, "mechanics_box_found")
	
	CharacterData.set_flag("Yuka/secret_info/hint_4", true)
	CharacterData.check_if_all_hints("Yuka")
	print("You found a hint about Yuka!")

func _on_poster_pressed():
	SceneManager.play_click_sfx()
	
	DialogueManager.start_dialogue(yukas_dialogue_tree, "poster_found")
	
	CharacterData.set_flag("Yuka/secret_info/hint_3", true)
	CharacterData.check_if_all_hints("Yuka")
	print("You found a hint about Yuka!")
