extends Control



func _on_corkboard_area_mouse_entered() -> void:
	
	# Apply glow by enabling shader parameter
	if %Corkboard.material is ShaderMaterial:
		%Corkboard.material.set("shader_parameter/glow_enabled", true)



func _on_corkboard_area_mouse_exited() -> void:
	
	# Disable glow
	if %Corkboard.material is ShaderMaterial:
		%Corkboard.material.set("shader_parameter/glow_enabled", false)
