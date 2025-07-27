extends Control

signal close_journal


func close_map():
	emit_signal("close_journal")


func _on_kitchen_pressed() -> void:
	if not SceneManager.current_room_name == "kitchen":
		SceneManager.change_scene("res://scenes/rooms/kitchen/kitchen.tscn")
		close_map()


func _on_bathroom_pressed() -> void:
	if not SceneManager.current_room_name == "bathroom":
		SceneManager.change_scene("res://scenes/rooms/bathroom/bathroom.tscn")
		close_map()


func _on_laundry_pressed() -> void:
	if not SceneManager.current_room_name == "laundry":
		SceneManager.change_scene("res://scenes/rooms/laundry/laundry.tscn")
		close_map()


func _on_parents_room_pressed() -> void:
	if not SceneManager.current_room_name == "parents_room":
		SceneManager.change_scene("res://scenes/rooms/parents_room/parents_room.tscn")
		close_map()


func _on_yukas_room_pressed() -> void:
	if not SceneManager.current_room_name == "yukas_room":
		SceneManager.change_scene("res://scenes/rooms/yukas_room/yukas_room.tscn")
		close_map()


func _on_sosukes_room_pressed() -> void:
	if not SceneManager.current_room_name == "sosukes_room":
		SceneManager.change_scene("res://scenes/rooms/sosukes_room/sosukes_room.tscn")
		close_map()


func _on_living_room_pressed() -> void:
	if not SceneManager.current_room_name == "living_room":
		SceneManager.change_scene("res://scenes/rooms/living_room/living_room.tscn")
		close_map()


func _on_hallway_pressed() -> void:
	if not SceneManager.current_room_name == "hallway":
		SceneManager.change_scene("res://scenes/rooms/hallway/hallway.tscn")
		close_map()


func _on_office_pressed() -> void:
	if not SceneManager.current_room_name == "office":
		SceneManager.change_scene("res://scenes/rooms/office/office.tscn")
		close_map()


func _on_garage_pressed() -> void:
	if not SceneManager.current_room_name == "garage":
		SceneManager.change_scene("res://scenes/rooms/garage/garage.tscn")
		close_map()



func _on_shed_pressed() -> void:
	if not SceneManager.current_room_name == "shed":
		SceneManager.change_scene("res://scenes/rooms/shed/shed.tscn")
		close_map()


func _on_grandparents_room_pressed() -> void:
	if not SceneManager.current_room_name == "grandparents_room":
		SceneManager.change_scene("res://scenes/rooms/grandparents_room/grandparents_room.tscn")
		close_map()


func _on_yard_pressed() -> void:
	if not SceneManager.current_room_name == "yard":
		SceneManager.change_scene("res://scenes/rooms/yard/yard.tscn")
		close_map()
