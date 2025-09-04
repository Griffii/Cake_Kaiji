extends Control



func _on_button_pressed() -> void:
	SceneManager.change_scene("laundry_mini_game")
	SceneManager.in_mini_game = true
