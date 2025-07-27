extends Button

@onready var anim_player = $AnimationPlayer

func _ready() -> void:
	await get_tree().process_frame # Wait so the button calculates its size after text update
	pivot_offset = size / 2
	
	anim_player.play("appear")



func _on_mouse_entered() -> void:
	scale = Vector2(1.05,1.05)
	SceneManager.play_hover_sfx()
func _on_mouse_exited() -> void:
	scale = Vector2(1,1)

func _on_pressed() -> void:
	%close_sfx.play()
