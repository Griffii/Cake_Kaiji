extends Control



func _on_corkboard_area_mouse_entered() -> void:
	SceneManager.play_hover_sfx()
	# Apply glow by enabling shader parameter
	if %Corkboard.material is ShaderMaterial:
		%Corkboard.material.set("shader_parameter/glow_enabled", true)
func _on_corkboard_area_mouse_exited() -> void:
	# Disable glow
	if %Corkboard.material is ShaderMaterial:
		%Corkboard.material.set("shader_parameter/glow_enabled", false)



func _on_lamp_area_mouse_entered() -> void:
	SceneManager.play_hover_sfx()
	# Apply glow by enabling shader parameter
	if %LavaLamp.material is ShaderMaterial:
		%LavaLamp.material.set("shader_parameter/glow_enabled", true)
func _on_Lamp_area_mouse_exited() -> void:
	# Disable glow
	if %LavaLamp.material is ShaderMaterial:
		%LavaLamp.material.set("shader_parameter/glow_enabled", false)


func _on_test_button_pressed() -> void:
	SceneManager.play_click_sfx()
	DialogueManager.start_dialogue("res://data/dialogue_trees/test_dialogue.json","test_types_of_speech")

func _on_emotions_test_btn_pressed():
	SceneManager.play_click_sfx()
	DialogueManager.start_dialogue("res://data/dialogue_trees/test_dialogue.json","test_emotions")
