extends Control

@onready var anim_player = $AnimationPlayer

func _ready() -> void:
	%Map.close_journal.connect(close)
	
	# Hide when first loaded in
	visible = false


func open():
	anim_player.play("open")
	SceneManager.in_menu = true

func close():
	anim_player.play("close")
	SceneManager.in_menu = false


func _on_close_button_pressed() -> void:
	MenuManager.close_journal_menu()
