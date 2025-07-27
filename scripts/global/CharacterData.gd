extends Node


#### HOW TO USE GET/SET ####
#
## Check if Sosuke knows the secret
# CharacterData.get_flag("NAME/secret_info/sosuke_knows_secret")
#
## Set where sosuke thinks they were in the afternoon
# CharacterDate.set_flag("NAME/schedule/afternoon/sosuke_thinks_place", true)


var characters = {
	"Sosuke": {
		"character_name": "Sosuke",
		"sub_name": "",
		"age": 11,
		"likes": ["Cake", "Mysteries"],
		"dislikes": ["Swimming"],
		"secret": "",
		"bg_color_code": "#4CAF50",
		
		"portraits": {
			"default": preload("res://scenes/characters/Sosuke/Sosuke_default.png"),
			#"happy": preload("res://scenes/characters/Sosuke/Sosuke_happy.png"),
			#"sad": preload("res://scenes/characters/Sosuke/Sosuke_sad.png"),
			#"surprised": preload("res://scenes/characters/Sosuke/Sosuke_surprised.png"),
			#"thinking": preload("res://scenes/characters/Sosuke/Sosuke_thinking.png")
		},
		
		"knowledge": {
			"yuka_secret_known": false,
			"haruto_secret_known": false,
			"ken_secret_known": false,
			"karin_secret_known": false,
			"kenichiro_secret_known": false,
			"kiyomi_secret_known": false,
			"mikan_secret_known": false,
			"pii_chan_secret_known": false
		},
		
		"collected_hints": []
	},
	
	
	"Yuka": {
		"character_name": "Yuka",
		"sub_name": "Big Sister",
		"age": 16,
		"likes": ["Studying"],
		"dislikes": ["Fun"],
		"secret": "Is a street racer.",
		"bg_color_code": "#FF69B4",
		
		"portraits": {
			"default": preload("res://scenes/characters/Yuka/Yuka_default.png"),
			#"happy": preload("res://scenes/characters/Yuka/Yuka_happy.png"),
			#"sad": preload("res://scenes/characters/Yuka/Yuka_sad.png"),
			#"surprised": preload("res://scenes/characters/Yuka/Yuka_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"place": "School",
				"place_lie": "",
				"activity": "Student council meeting",
				"activity_lie": "",
				"sosuke_thinks_place": "School",
				"sosuke_thinks_activity": "Student council meeting"
			},
			"afternoon": {
				"place": "The mall",
				"place_lie": "",
				"activity": "Street racing",
				"activity_lie": "",
				"sosuke_thinks_place": "The mall",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"place": "Kitchen",
				"place_lie": "",
				"activity": "Eating snacks",
				"activity_lie": "",
				"sosuke_thinks_place": "Kitchen",
				"sosuke_thinks_activity": "???"
			}
		},
		
		"cake_info": {
			"did_eat_cake": true,
			"will_reveal_cake": false,
			"sosuke_knows_cake": false
		},
		
		"secret_info": {
			"sosuke_knows_secret": false,
			"sosuke_has_secret_hints": false,
			"hint_1": "Leather jackets in her closet.",
			"hint_2": "Mysterious note from her rival in the garage.",
			"hint_3": "Racing movie poster in her room.",
			"hint_4": "Mechanics box under her bed."
		}
	},
	
	
	"Haruto": {
		"character_name": "Haru",
		"sub_name": "Baby Brother",
		"age": 2,
		"likes": ["Napping", "Toys"],
		"dislikes": ["Baths"],
		"secret": "He is a robot genius.",
		"bg_color_code": "#4682B4",
		
		"portraits": {
			"default": preload("res://scenes/characters/Haruto/Haruto_default.png"),
			#"happy": preload("res://scenes/characters/Haruto/Haruto_happy.png"),
			#"sad": preload("res://scenes/characters/Haruto/Haruto_sad.png"),
			#"surprised": preload("res://scenes/characters/Haruto/Haruto_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"place": "Parent's Room",
				"place_lie": "",
				"activity": "Sleeping",
				"activity_lie": "",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"afternoon": {
				"place": "Bathroom",
				"place_lie": "",
				"activity": "Pooping",
				"activity_lie": "",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"place": "Living Room",
				"place_lie": "",
				"activity": "Making a robot",
				"activity_lie": "",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			}
		},
		
		"cake_info": {
			"did_eat_cake": true,
			"will_reveal_cake": false,
			"sosuke_knows_cake": false
		},
		
		"secret_info": {
			"sosuke_knows_secret": false,
			"sosuke_has_secret_hints": false,
			"hint_1": "Cake themed toys",
			"hint_2": "Frosting on his fingers",
			"hint_3": "Crumbs on his toys",
			"hint_4": "Cake smeared robot"
		}
	},
	
	
	"Ken": {
		"character_name": "Dad",
		"sub_name": "Ken Kaiji",
		"age": 40,
		"likes": ["Working", "His Family"],
		"dislikes": ["Asparagus"],
		"secret": "He builds spy tech.",
		"bg_color_code": "#32CD32",
		
		"portraits": {
			"default": preload("res://scenes/characters/Ken/Ken_default.png"),
			#"happy": preload("res://scenes/characters/Ken/Ken_happy.png"),
			#"sad": preload("res://scenes/characters/Ken/Ken_sad.png"),
			#"surprised": preload("res://scenes/characters/Ken/Ken_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"place": "Office",
				"place_lie": "",
				"activity": "Watching spy cameras",
				"activity_lie": "Calling teh bank",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"afternoon": {
				"place": "Kitchen",
				"place_lie": "",
				"activity": "Eating cake",
				"activity_lie": "Having lunch",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"place": "Hallway",
				"place_lie": "",
				"activity": "Installing spy cameras",
				"activity_lie": "Fixing the lightbulbs",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			}
		},
		
		"cake_info": {
			"did_eat_cake": false,
			"will_reveal_cake": false,
			"sosuke_knows_cake": false
		},
		
		"secret_info": {
			"sosuke_knows_secret": false,
			"sosuke_has_secret_hints": false,
			"hint_1": "",
			"hint_2": "",
			"hint_3": "",
			"hint_4": ""
		}
	},
	
	
	"Karin": {
		"character_name": "Mom",
		"sub_name": "Karin Kaiji",
		"age": 38,
		"likes": ["Apple Juice"],
		"dislikes": ["Grape Juice", "Taxes"],
		"secret": "Sells black-market apple juice.",
		"bg_color_code": "#FFB6C1",
		
		"portraits": {
			"default": preload("res://scenes/characters/Karin/Karin_default.png"),
			#"happy": preload("res://scenes/characters/Karin/Karin_happy.png"),
			#"sad": preload("res://scenes/characters/Karin/Karin_sad.png"),
			#"surprised": preload("res://scenes/characters/Karin/Karin_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"place": "Kitchen",
				"place_lie": "",
				"activity": "Making apple juice",
				"activity_lie": "Making breakfast",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"afternoon": {
				"place": "Laundry Room",
				"place_lie": "",
				"activity": "Selling apple juice t othe Raccoon Bandits",
				"activity_lie": "Doing laundry",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"place": "Yard",
				"place_lie": "",
				"activity": "Drying Laundry",
				"activity_lie": "",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			}
		},
		
		"cake_info": {
			"did_eat_cake": false,
			"will_reveal_cake": false,
			"sosuke_knows_cake": false
		},
		
		"secret_info": {
			"sosuke_knows_secret": false,
			"sosuke_has_secret_hints": false,
			"hint_1": "",
			"hint_2": "",
			"hint_3": "",
			"hint_4": ""
		}
	},
	
	
	"Kenichiro": {
		"character_name": "Grandpa",
		"sub_name": "Kenichiro Kaiji",
		"age": 70,
		"likes": ["Physics"],
		"dislikes": ["Barley Tea"],
		"secret": "Is building a time machine.",
		"bg_color_code": "#8B0000",
		
		"portraits": {
			"default": preload("res://scenes/characters/Kenichiro/Kenichiro_default.png"),
			#"happy": preload("res://scenes/characters/Kenichiro/Kenichiro_happy.png"),
			#"sad": preload("res://scenes/characters/Kenichiro/Kenichiro_sad.png"),
			#"surprised": preload("res://scenes/characters/Kenichiro/Kenichiro_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"place": "Shed",
				"place_lie": "Grandparents Bedroom",
				"activity": "Working on his time machine",
				"activity_lie": "Sleeping in",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"afternoon": {
				"place": "Garage",
				"place_lie": "",
				"activity": "Looking for parts for his time machine",
				"activity_lie": "Fixing the lawn mower",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"place": "Shed",
				"place_lie": "Yard",
				"activity": "Going back in time to replace the cake",
				"activity_lie": "Mowing the lawn",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			}
		},
		
		"cake_info": {
			"did_eat_cake": false,
			"will_reveal_cake": false,
			"sosuke_knows_cake": false
		},
		
		"secret_info": {
			"sosuke_knows_secret": false,
			"sosuke_has_secret_hints": false,
			"hint_1": "Weird devices in the shed",
			"hint_2": "",
			"hint_3": "",
			"hint_4": ""
		}
	},
	
	
	"Kiyomi": {
		"character_name": "Grandma",
		"sub_name": "Kiyomi Kaiji",
		"age": 72,
		"likes": ["Magic", "Cooking"],
		"dislikes": ["Dust", "Bad manners"],
		"secret": "She practices cleaning magic.",
		"bg_color_code": "#9932CC",
		
		"portraits": {
			"default": preload("res://scenes/characters/Kiyomi/Kiyomi_default.png"),
			#"happy": preload("res://scenes/characters/Kiyomi/Kiyomi_happy.png"),
			#"sad": preload("res://scenes/characters/Kiyomi/Kiyomi_sad.png"),
			#"surprised": preload("res://scenes/characters/Kiyomi/Kiyomi_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"place": "",
				"place_lie": "",
				"activity": "",
				"activity_lie": "",
				"sosuke_thinks_place": "Grandparents Bedroom",
				"sosuke_thinks_activity": "???"
			},
			"afternoon": {
				"place": "",
				"place_lie": "",
				"activity": "",
				"activity_lie": "",
				"sosuke_thinks_place": "Kitchen",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"place": "",
				"place_lie": "",
				"activity": "",
				"activity_lie": "",
				"sosuke_thinks_place": "Living Room",
				"sosuke_thinks_activity": "???"
			}
		},
		
		"cake_info": {
			"did_eat_cake": false,
			"will_reveal_cake": false,
			"sosuke_knows_cake": false
		},
		
		"secret_info": {
			"sosuke_knows_secret": false,
			"sosuke_has_secret_hints": false,
			"hint_1": "",
			"hint_2": "",
			"hint_3": "",
			"hint_4": ""
		}
	},
	
	
	"Mikan": {
		"character_name": "Mikan",
		"sub_name": "Cat",
		"age": 6,
		"likes": ["Running", "Snacks"],
		"dislikes": ["Baths", "Birds"],
		"secret": "She hides stolen items.",
		"bg_color_code": "#FFA500",
		
		"portraits": {
			"default": preload("res://scenes/characters/Mikan/Mikan_default.png"),
			#"happy": preload("res://scenes/characters/Mikan/Mikan_happy.png"),
			#"sad": preload("res://scenes/characters/Mikan/Mikan_sad.png"),
			#"surprised": preload("res://scenes/characters/Mikan/Mikan_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"place": "",
				"place_lie": "",
				"activity": "",
				"activity_lie": "",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"afternoon": {
				"place": "",
				"place_lie": "",
				"activity": "",
				"activity_lie": "",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"place": "",
				"place_lie": "",
				"activity": "",
				"activity_lie": "",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			}
		},
		
		"cake_info": {
			"did_eat_cake": false,
			"will_reveal_cake": false,
			"sosuke_knows_cake": false
		},
		
		"secret_info": {
			"sosuke_knows_secret": false,
			"sosuke_has_secret_hints": false,
			"hint_1": "",
			"hint_2": "",
			"hint_3": "",
			"hint_4": ""
		}
	},
	
	
	"Pii-Chan": {
		"character_name": "Pii-Chan",
		"sub_name": "Bird",
		"age": 3,
		"likes": ["Seeds", "Flying"],
		"dislikes": ["Cats", "Loud noises"],
		"secret": "He can unlock cage doors.",
		"bg_color_code": "#00CED1",
		
		"portraits": {
			"default": preload("res://scenes/characters/Pii-Chan/Pii-Chan_default.png"),
			#"happy": preload("res://scenes/characters/Pii-Chan/Pii-Chan_happy.png"),
			#"sad": preload("res://scenes/characters/Pii-Chan/Pii-Chan_sad.png"),
			#"surprised": preload("res://scenes/characters/Pii-Chan/Pii-Chan_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"place": "",
				"place_lie": "",
				"activity": "",
				"activity_lie": "",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"afternoon": {
				"place": "",
				"place_lie": "",
				"activity": "",
				"activity_lie": "",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"place": "",
				"place_lie": "",
				"activity": "",
				"activity_lie": "",
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
				}
			},
			
			"cake_info": {
				"did_eat_cake": false,
				"will_reveal_cake": false,
				"sosuke_knows_cake": false
			},
			
			"secret_info": {
				"sosuke_knows_secret": false,
				"sosuke_has_secret_hints": false,
				"hint_1": "",
				"hint_2": "",
				"hint_3": "",
				"hint_4": ""
			}
		}
	}


func get_flag(path: String) -> Variant:
	var keys = path.split("/")
	var ref = characters
	for key in keys:
		if ref.has(key):
			ref = ref[key]
		else:
			return null
	return ref

func set_flag(path: String, value) -> void:
	var keys = path.split("/")
	var ref = characters
	for i in range(keys.size() - 1):
		if not ref.has(keys[i]):
			ref[keys[i]] = {}
		ref = ref[keys[i]]
	ref[keys[-1]] = value
