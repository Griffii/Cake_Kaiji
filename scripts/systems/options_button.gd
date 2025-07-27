extends Button

@onready var anim_player = $AnimationPlayer

func _ready() -> void:
	#visible = false # Hide until appear anim is called
	await get_tree().process_frame # Wait so the button calculates its size after text update
	pivot_offset = size / 2

func _on_mouse_entered() -> void:
	scale = Vector2(1.05,1.05)
	SceneManager.play_hover_sfx()
func _on_mouse_exited() -> void:
	scale = Vector2(1,1)

func clear_button():
	anim_player.play("disappear")
	await anim_player.animation_finished
	queue_free()
