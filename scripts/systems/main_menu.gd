extends Control

@onready var play_btn = %Play_Button



func _on_play_button_pressed():
	SceneManager.play_click_sfx()
	SceneManager.change_scene("sosukes_room")

func _on_play_button_mouse_entered() -> void:
	play_btn.scale = Vector2(1.05, 1.05)
	SceneManager.play_hover_sfx()
func _on_play_button_mouse_exited() -> void:
	play_btn.scale = Vector2(1, 1)



func _on_settings_button_pressed():
	SceneManager.play_click_sfx()
	
	# Flash the "no" label.
	%Settings_Menu.visible = true
	await get_tree().create_timer(0.5).timeout
	%Settings_Menu.visible = false

func _on_settings_button_mouse_entered() -> void:
	%Settings_Button.scale = Vector2(1.05,1.05)
	SceneManager.play_hover_sfx()
func _on_settings_button_mouse_exited() -> void:
	%Settings_Button.scale = Vector2(1,1)
