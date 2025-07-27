extends Node

var current_scene: Node = null
var current_room_name: String = ""
var transition: Node = null
var overlay: Node = null

var in_dialogue: bool = false
var in_menu: bool = true # True cuz we start in the main menu


func _ready() -> void:
	await get_tree().process_frame
	#current_scene = get_tree().root.get_node("MainMenu")
	
	# Load in the scene transition manager
	transition = preload("res://scenes/ui/scene_transition.tscn").instantiate()
	get_tree().root.add_child(transition)
	
	# Load in the game overlay
	overlay = preload("res://scenes/ui/game_overlay.tscn").instantiate()
	get_tree().root.add_child(overlay)
	




func change_scene(path: String):
	await transition.play_fade_in()
	
	# Free the old scene
	if current_scene:
		current_scene.queue_free()
	
	# Load the new scene
	var new_scene = load(path).instantiate()
	get_tree().root.add_child(new_scene)
	current_scene = new_scene
	
	await transition.play_fade_out()
	
	set_current_room_and_update_flags(path)
	
	# Changing scenes takes you out of menus/out of the main menu
	SceneManager.in_menu = false


func set_current_room_and_update_flags(path: String):
	var room_keywords = [
		"bathroom", "garage", "grandparents_room", "hallway", "kitchen",
		"laundry", "living_room", "office", "parents_room", "shed",
		"sosukes_room", "yard", "yukas_room"
	]
	
	current_room_name = "unknown"
	
	for keyword in room_keywords:
		if path.findn(keyword) != -1:
			current_room_name = keyword
			break
	
	# Update global flags if a valid room was found
	if current_room_name != "unknown" and GameFlags.flags["rooms"].has(current_room_name):
		# Mark as visited
		GameFlags.set_flag("rooms/%s/visited" % current_room_name, true)
		
		# Increment visit count
		var visit_count = GameFlags.get_flag("rooms/%s/visit_count" % current_room_name)
		GameFlags.set_flag("rooms/%s/visit_count" % current_room_name, visit_count + 1)


func play_hover_sfx():
	overlay.hover_sfx.play()
func play_click_sfx():
	overlay.click_sfx.play()
