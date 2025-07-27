extends Character


func _ready() -> void:
	character_name = "Kiyomi"
	sub_name = "Grandma"
	age = 68
	likes = ["Magic Tricks"]
	dislikes = ["Dirty Laundry"]
	secret = "Is a magic cleaning witch."
	default_portrait = preload("res://scenes/characters/Kiyomi/Kiyomi_Default.png")
	bg_color_code = "#E8DAEF" #Pale Lavender
	
	
	## On start up Sosuke knows nothing - Will not reveal cake info
	sosuke_knows_secret = false
	sosuke_has_secret_hints = false
	sosuke_knows_cake = false
	did_eat_cake = true
	will_reveal_cake = false
	
	## Set locations for morning, afternoon, evening
	## Set activities for morning, afternoon, evening
	morning_place = "Kitchen"
	morning_activity = "Making breakfast"
	
	afternoon_place = "Grandparents Bedroom"
	afternoon_place_lie = "Living Room"
	afternoon_activity = "Making a magic potion, with cake"
	afternoon_activity_lie = "Knitting"
	
	evening_place = "Living Room"
	evening_activity = "Playing with Haruto"
