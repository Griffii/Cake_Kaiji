extends CanvasLayer


func _ready() -> void:
	%Map.close_journal.connect(close_journal_menu)


func close_journal_menu():
	SceneManager.in_menu = false
	queue_free()


func _on_close_button_pressed() -> void:
	close_journal_menu()
