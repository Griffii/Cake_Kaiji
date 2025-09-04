extends Control

signal close_journal


func close_map():
	emit_signal("close_journal")


func _on_kitchen_pressed() -> void:
	if not SceneManager.current_room_name == "kitchen":
		SceneManager.change_scene("kitchen")
		close_map()


func _on_bathroom_pressed() -> void:
	if not SceneManager.current_room_name == "bathroom":
		SceneManager.change_scene("bathroom")
		close_map()


func _on_laundry_pressed() -> void:
	if not SceneManager.current_room_name == "laundry":
		SceneManager.change_scene("laundry")
		close_map()


func _on_parents_room_pressed() -> void:
	if not SceneManager.current_room_name == "parents_room":
		SceneManager.change_scene("parents_room")
		close_map()


func _on_yukas_room_pressed() -> void:
	if not SceneManager.current_room_name == "yukas_room":
		SceneManager.change_scene("yukas_room")
		close_map()


func _on_sosukes_room_pressed() -> void:
	if not SceneManager.current_room_name == "sosukes_room":
		SceneManager.change_scene("sosukes_room")
		close_map()


func _on_living_room_pressed() -> void:
	if not SceneManager.current_room_name == "living_room":
		SceneManager.change_scene("living_room")
		close_map()


func _on_hallway_pressed() -> void:
	if not SceneManager.current_room_name == "hallway":
		SceneManager.change_scene("hallway")
		close_map()


func _on_office_pressed() -> void:
	if not SceneManager.current_room_name == "office":
		SceneManager.change_scene("office")
		close_map()


func _on_garage_pressed() -> void:
	if not SceneManager.current_room_name == "garage":
		SceneManager.change_scene("garage")
		close_map()



func _on_shed_pressed() -> void:
	if not SceneManager.current_room_name == "shed":
		SceneManager.change_scene("shed")
		close_map()


func _on_grandparents_room_pressed() -> void:
	if not SceneManager.current_room_name == "grandparents_room":
		SceneManager.change_scene("grandparents_room")
		close_map()


func _on_yard_pressed() -> void:
	if not SceneManager.current_room_name == "yard":
		SceneManager.change_scene("yard")
		close_map()
