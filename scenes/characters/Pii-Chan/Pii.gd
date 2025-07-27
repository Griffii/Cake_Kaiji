extends Character


func _ready() -> void:
	character_name = "Pii-Chan"
	sub_name = "Bird"
	age = 3
	likes = ["Mikan"]
	dislikes = ["Cages"]
	secret = "No Secret"
	default_portrait = preload("res://scenes/characters/Pii-Chan/Pii-Chan_Default.png")
	bg_color_code = "#E3F2FD" #Powder Blue
	
	
	## On start up Sosuke knows nothing - Will not reveal cake info
	sosuke_knows_secret = false
	sosuke_has_secret_hints = false
	sosuke_knows_cake = false
	did_eat_cake = true
	will_reveal_cake = false
	
	## Set locations for morning, afternoon, evening
	## Set activities for morning, afternoon, evening
	morning_place = "Bathroom"
	morning_activity = "Singing"
	
	afternoon_place = "Living Room"
	afternoon_activity = "Battling Mikan"
	
	evening_place = "Hallway"
	evening_activity = "Patroling"
