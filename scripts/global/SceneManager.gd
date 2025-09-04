extends Node

var current_scene: Node = null
var current_room_name: String = ""
var transition: Node = null
var overlay: Node = null

var in_dialogue: bool = false
var in_menu: bool = false 
var in_choice_menu: bool = false
var choice_menu_paused: bool = false
var in_mini_game: bool = false

### ROOM SCENE PATHS ###
var scene_paths = {
	# Standard Rooms
	"kitchen": "res://scenes/rooms/kitchen/kitchen.tscn",
	"bathroom": "res://scenes/rooms/bathroom/bathroom.tscn",
	"garage": "res://scenes/rooms/garage/garage.tscn",
	"grandparents_room": "res://scenes/rooms/grandparents_room/grandparents_room.tscn",
	"hallway": "res://scenes/rooms/hallway/hallway.tscn",
	"laundry": "res://scenes/rooms/laundry/laundry.tscn",
	"living_room": "res://scenes/rooms/living_room/living_room.tscn",
	"office": "res://scenes/rooms/office/office.tscn",
	"parents_room": "res://scenes/rooms/parents_room/parents_room.tscn",
	"shed": "res://scenes/rooms/shed/shed.tscn",
	"sosukes_room": "res://scenes/rooms/sosukes_room/sosukes_room.tscn",
	"yard": "res://scenes/rooms/yard/yard.tscn",
	"yukas_room": "res://scenes/rooms/yukas_room/yukas_room.tscn",
	# Mini Games
	"laundry_mini_game": "res://scenes/mini_games/laundry_mini_game.tscn"
}


func _ready() -> void:
	await get_tree().process_frame
	
	if get_tree().root.has_node("MainMenu"):
		current_scene = get_tree().root.get_node("MainMenu")
		in_menu = true
	
	# Load in the scene transition manager
	transition = preload("res://scenes/ui/scene_transition.tscn").instantiate()
	get_tree().root.add_child(transition)
	
	# Load in the game overlay
	overlay = preload("res://scenes/ui/game_overlay.tscn").instantiate()
	get_tree().root.add_child(overlay)


### SCENE MANAGEMENT ###
func change_scene(scene: String):
	await transition.play_fade_in()
	
	var path = get_scene_path(scene)
	
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

func get_scene_path(scene_name: String) -> String:
	if scene_name in scene_paths:
		return scene_paths[scene_name]
	else:
		push_error("No scene path found for: ", scene_name)
		return ""

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


### GLOBAL OVERLAY FUNCS ##########################################################
func play_hover_sfx():
	overlay.hover_sfx.play()
func play_click_sfx():
	overlay.click_sfx.play()
func play_error_sfx():
	overlay.error_sfx.play()
func play_note_sfx():
	overlay.note_sfx.play()

func play_update_notebook():
	overlay.play_update_notebook()
