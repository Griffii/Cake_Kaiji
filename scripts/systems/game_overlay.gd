extends CanvasLayer

@onready var anim_player = $AnimationPlayer

# Audio
@onready var hover_sfx = $hover_sfx
@onready var click_sfx = $click_sfx
@onready var error_sfx = $error_sfx
@onready var notes_sfx = $notes_sfx

@onready var journal_btn = %Journal_Button

func _process(_delta: float) -> void:
	if SceneManager.in_dialogue or SceneManager.in_menu or SceneManager.in_mini_game:
		journal_btn.visible = false
	else:
		journal_btn.visible = true


func _on_journal_button_pressed() -> void:
	click_sfx.play()
	MenuManager.open_journal_menu()



func _on_journal_button_mouse_entered() -> void:
	%Journal_Button.scale = Vector2(1.05,1.05)
	hover_sfx.play()
func _on_journal_button_mouse_exited() -> void:
	%Journal_Button.scale = Vector2(1,1)


func play_update_notebook():
	anim_player.play("update_notebook")
