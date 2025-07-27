extends Control




func _on_play_button_pressed():
	SceneManager.play_click_sfx()
	SceneManager.change_scene("res://scenes/rooms/sosukes_room/sosukes_room.tscn")

func _on_play_button_mouse_entered() -> void:
	%Play_Button.scale = Vector2(1.05,1.05)
	SceneManager.play_hover_sfx()
func _on_play_button_mouse_exited() -> void:
	%Play_Button.scale = Vector2(1,1)



func _on_quit_button_mouse_entered() -> void:
	%Quit_Button.scale = Vector2(1.05,1.05)
	SceneManager.play_hover_sfx()
func _on_quit_button_mouse_exited() -> void:
	%Quit_Button.scale = Vector2(1,1)
