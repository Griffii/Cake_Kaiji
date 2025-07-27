extends Character


func _ready() -> void:
	character_name = "Mikan"
	sub_name = "Cat"
	age = 6
	likes = ["War, Victory"]
	dislikes = ["Pii-Chan"]
	secret = "No Secret"
	default_portrait = preload("res://scenes/characters/Mikan/Mikan_Default.png")
	bg_color_code = "#F8D7DA" #Pale Red
	
	
	## On start up Sosuke knows nothing - Will not reveal cake info
	sosuke_knows_secret = false
	sosuke_has_secret_hints = false
	sosuke_knows_cake = false
	did_eat_cake = true
	will_reveal_cake = false
	
	## Set locations for morning, afternoon, evening
	## Set activities for morning, afternoon, evening
	morning_place = "Kitchen"
	morning_place_lie = "Parents Bedroom"
	morning_activity = "Stealing cake for a trap"
	morning_activity_lie = "Preparing his defenses"
	
	afternoon_place = "Living Room"
	afternoon_activity = "Battling Pii-Chan"
	
	evening_place = "Yard"
	evening_activity = "Recovering from battle"
