extends CanvasLayer

@onready var hover_sfx = $hover_sfx
@onready var click_sfx = $click_sfx

func _process(_delta: float) -> void:
	if SceneManager.in_dialogue or SceneManager.in_menu:
		visible = false
	else:
		visible = true


func _on_journal_button_pressed() -> void:
	click_sfx.play()
	DialogueManager.open_journal_menu()



func _on_journal_button_mouse_entered() -> void:
	%Journal_Button.scale = Vector2(1.05,1.05)
	hover_sfx.play()
func _on_journal_button_mouse_exited() -> void:
	%Journal_Button.scale = Vector2(1,1)
