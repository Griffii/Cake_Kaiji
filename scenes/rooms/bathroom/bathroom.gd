extends Control



func _ready() -> void:
	await get_tree().create_timer(0.5).timeout # Half second pause to wait for scene transition
	#DialogueManager.show_dialogue()
