extends Node

@onready var basket1 = $BasketContainer/Basket1
@onready var basket2 = $BasketContainer/Basket2
@onready var basket3 = $BasketContainer/Basket3

@onready var spawn_timer: Timer = $SpawnTimer
@onready var game_timer: Timer = $GameTimer
@onready var timer_label: Label = $TimerLabel
@onready var points_label: Label = $PointsLabel
@onready var shirts_container: Node2D = $Shirts

@onready var menu = $Game_Menu/Panel
@onready var menu_points_label = $Game_Menu/Panel/Menu_Points_Label
@onready var anim_player = $AnimationPlayer

@export var shirt_scene: PackedScene
@export var game_time: int = 31                        # Total game time (seconds)
@export var spawn_interval: float = 1.0               # Spawn every X seconds
@export var score_goal: int = 15

var score: int = 0
var max_score: int = 30
var pending_words: Array = []
var word_sets = {
	"Fruits": [
		"apple", "banana", "orange", "grape", "strawberry",
		"pineapple", "watermelon", "peach", "mango", "cherry"
	],
	"Animals": [
		"dog", "cat", "lion", "gorilla", "horse",
		"elephant", "tiger", "zebra", "kangaroo", "panda"
	],
	"Vegetables": [
		"carrot", "potato", "onion", "cabbage", "green pepper",
		"tomato", "broccoli", "spinach", "eggplant", "lettuce"
	]
}


@onready var shirt_textures: Array[Texture2D] = [
	preload("res://assets/images/shirts/shirt1.png"),
	preload("res://assets/images/shirts/shirt2.png"),
	preload("res://assets/images/shirts/shirt3.png"),
	preload("res://assets/images/shirts/shirt4.png"),
	preload("res://assets/images/shirts/shirt5.png")
]

 

func _ready():
	SceneManager.in_mini_game = true
	menu.visible = false
	start_game()

func _process(_delta):
	# Update timer label with remaining time
	timer_label.text = str(int(game_timer.time_left))
	
	if score >= max_score:
		_on_GameTimer_timeout()

func start_game():
	# Wipe old shirts
	for child in shirts_container.get_children():
		child.queue_free()
	
	score = 0
	
	# Flatten dictionary into list of {word, theme}
	for theme in word_sets.keys():
		for word in word_sets[theme]:
			pending_words.append({"word": word, "theme": theme})
	pending_words.shuffle()
	
	game_timer.wait_time = game_time
	game_timer.start()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()
	points_label.text = str(score)
	
	%MiniGame_Music.play()



func _on_SpawnTimer_timeout():
	print("Spawning Shirt")
	if pending_words.size() > 0:
		spawn_shirt(pending_words.pop_front())
	else:
		spawn_timer.stop()

func _on_GameTimer_timeout():
	# Game over: stop spawning and maybe show results
	game_timer.stop()
	spawn_timer.stop()
	PhysicsServer2D.set_active(false)
	
	%MiniGame_Music.stop()
	%FinishSound.play()
	
	menu_points_label.text = "Points: " + str(score)
	
	if score < score_goal:
		%Continue_Button.disabled = true
		%Continue_Button.add_theme_color_override("font_outline_color", Color.BLACK)
	else:
		%Continue_Button.disabled = false
		%Continue_Button.add_theme_color_override("font_outline_color", Color.WHITE)

	
	anim_player.play("open_menu")


func spawn_shirt(data: Dictionary):
	var shirt = shirt_scene.instantiate()
	shirts_container.add_child(shirt)
	
	var random_texture = shirt_textures.pick_random()
	shirt.set_shirt(random_texture, data["word"], data["theme"])
	
	var x_pos = randf_range(200.0, 1700.0)
	var y_pos = -200.0
	shirt.global_position = Vector2(x_pos, y_pos)

func _on_basket_body_entered(body: Node, basket: Sprite2D):
	if body is RigidBody2D and body.has_method("set_shirt"):
		var shirt_theme = body.theme
		if shirt_theme == basket.theme:
			# Correct
			%CorrectSound.play()
			score += 1
			points_label.text = str(score)
		else:
			# Wrong
			%WrongSound.play()
			pending_words.append({"word": body.word_label.text, "theme": shirt_theme})
			pending_words.shuffle()
			if spawn_timer.is_stopped():
				spawn_timer.start()
		# Remove shirt
		body.queue_free()


func _on_continue_button_pressed() -> void:
	SceneManager.play_click_sfx()
	PhysicsServer2D.set_active(true)
	# Set GameFlags for whatever is gained from this game
	######################################################
	SceneManager.change_scene("laundry")
	SceneManager.in_mini_game = false


func _on_restart_button_pressed() -> void:
	SceneManager.play_click_sfx()
	PhysicsServer2D.set_active(true)
	anim_player.play("close_menu")
	await anim_player.animation_finished
	start_game()
