extends Character


func _ready() -> void:
	character_name = "Kenichiro"
	sub_name = "Grandpa"
	age = 72
	likes = ["Physics"]
	dislikes = ["Sci-fi"]
	secret = "Is building a time machine."
	default_portrait = preload("res://scenes/characters/Kenichiro/Kenichiro_Default.png")
	bg_color_code = "#E8DAEF" #Pale Lavender
	
	
	## On start up Sosuke knows nothing - Will not reveal cake info
	sosuke_knows_secret = false
	sosuke_has_secret_hints = false
	sosuke_knows_cake = false
	did_eat_cake = true
	will_reveal_cake = false
	
	## Set locations for morning, afternoon, evening
	## Set activities for morning, afternoon, evening
	morning_place = "Shed"
	morning_place_lie = "Grandparents Bedroom"
	morning_activity = "Working on his time machine"
	morning_activity_lie = "Sleeping in"
	
	afternoon_place = "Garage"
	afternoon_activity = "Looking for parts for his time machine"
	afternoon_activity_lie = "Fixing the lawn mower"
	
	evening_place = "Shed"
	evening_place_lie = "Yard"
	evening_activity = "Going back in time to replace the cake"
	evening_activity_lie = "Mowing the lawn"
