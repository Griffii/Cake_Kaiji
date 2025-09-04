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
			"default": preload("res://scenes/characters/Sosuke/Sosuke_Default.png"),
			"happy": preload("res://scenes/characters/Sosuke/Sosuke_Happy.png"),
			"sad": preload("res://scenes/characters/Sosuke/Sosuke_Sad.png"),
			"surprised": preload("res://scenes/characters/Sosuke/Sosuke_Surprised.png"),
			"thinking": preload("res://scenes/characters/Sosuke/Sosuke_Thinking.png")
		},
		
		"knowledge": {
			"yuka_secret_known": false,
			"haruto_secret_known": false,
			"ken_secret_known": false,
			"karin_secret_known": false,
			"ichiro_secret_known": false,
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
			"portrait": preload("res://scenes/characters/Yuka/Yuka_Portrait.png"),
			"default": preload("res://scenes/characters/Yuka/Yuka_Default.png"),
			#"happy": preload("res://scenes/characters/Yuka/Yuka_happy.png"),
			#"sad": preload("res://scenes/characters/Yuka/Yuka_sad.png"),
			#"surprised": preload("res://scenes/characters/Yuka/Yuka_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"afternoon": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			}
		},
		
		"secret_info": {
			"sosuke_knows_secret": false,
			"sosuke_has_secret_hints": false,
			"sosuke_knows_cake": false,
			"ate_cake": true,
			"hint_1": false, # "Leather jackets in her closet.",
			"hint_2": false, # "Mysterious note from her rival in the garage.",
			"hint_3": false, # "Racing movie poster in her room.",
			"hint_4": false # "Mechanics box under her bed."
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
			"portrait": preload("res://scenes/characters/Haruto/Haruto_default.png"),
			"default": preload("res://scenes/characters/Haruto/Haruto_default.png"),
			#"happy": preload("res://scenes/characters/Haruto/Haruto_happy.png"),
			#"sad": preload("res://scenes/characters/Haruto/Haruto_sad.png"),
			#"surprised": preload("res://scenes/characters/Haruto/Haruto_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"afternoon": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			}
		},
		
		"secret_info": {
			"sosuke_knows_secret": false,
			"sosuke_has_secret_hints": false,
			"sosuke_knows_cake": false,
			"ate_cake": true,
			"hint_1": false, # "Cake themed toys",
			"hint_2": false, # "Frosting on his fingers",
			"hint_3": false, # "Crumbs on his toys",
			"hint_4": false # "Cake smeared robot"
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
			"portrait": preload("res://scenes/characters/Ken/Ken_Portrait.png"),
			"default": preload("res://scenes/characters/Ken/Ken_Default.png"),
			#"happy": preload("res://scenes/characters/Ken/Ken_happy.png"),
			#"sad": preload("res://scenes/characters/Ken/Ken_sad.png"),
			#"surprised": preload("res://scenes/characters/Ken/Ken_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"afternoon": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			}
		},
		
		
		"secret_info": {
			"sosuke_knows_secret": false,
			"sosuke_has_secret_hints": false,
			"sosuke_knows_cake": false,
			"ate_cake": true,
			"hint_1": false, # "Wires coming out of the light by his office",
			"hint_2": false, # "Recording pen left in the hallway",
			"hint_3": false, # "Broken camera in his bedroom",
			"hint_4": ""
		}
	},
	
	
	"Karin": {
		"character_name": "Mom",
		"sub_name": "Karin Kaiji",
		"age": 38,
		"likes": ["Cooking", "Apple Juice"],
		"dislikes": ["Taxes", "Grape Juice"],
		"secret": "Sells apple juice to raccoons.",
		"bg_color_code": "#FFB6C1",
		
		"portraits": {
			"portrait": preload("res://scenes/characters/Karin/Karin_Portrait.png"),
			"default": preload("res://scenes/characters/Karin/Karin_default.png"),
			#"happy": preload("res://scenes/characters/Karin/Karin_happy.png"),
			#"sad": preload("res://scenes/characters/Karin/Karin_sad.png"),
			#"surprised": preload("res://scenes/characters/Karin/Karin_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"afternoon": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			}
		},
		
		"secret_info": {
			"sosuke_knows_secret": false,
			"sosuke_has_secret_hints": false,
			"sosuke_knows_cake": false,
			"ate_cake": false,
			"hint_1": false, # "Apple juice spilled in the kitchen",
			"hint_2": false, # "Scratch marks on the floor in the laundry room",
			"hint_3": "",
			"hint_4": ""
		}
	},
	
	
	"Ichiro": {
		"character_name": "Grandpa",
		"sub_name": "Ichiro Kaiji",
		"age": 70,
		"likes": ["Physics"],
		"dislikes": ["Barley Tea"],
		"secret": "Is building a time machine.",
		"bg_color_code": "#8B0000",
		
		"portraits": {
			"portrait": preload("res://scenes/characters/Ichiro/Ichiro_Portrait.png"),
			"default": preload("res://scenes/characters/Ichiro/Ichiro_Default.png"),
			#"happy": preload("res://scenes/characters/Ichiro/Ichiro_happy.png"),
			#"sad": preload("res://scenes/characters/Ichiro/Ichiro_sad.png"),
			#"surprised": preload("res://scenes/characters/Ichiro/Ichiro_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"has_place_lie": true,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"afternoon": {
				"has_place_lie": true,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			}
		},
		
		"secret_info": {
			"sosuke_knows_secret": false,
			"sosuke_has_secret_hints": false,
			"sosuke_knows_cake": false,
			"ate_cake": false,
			"hint_1": false,
			"hint_2": false,
			"hint_3": false,
			"hint_4": false
		}
	},
	
	
	"Kiyomi": {
		"character_name": "Grandma",
		"sub_name": "Kiyomi Kaiji",
		"age": 68,
		"likes": ["Magic", "Cooking"],
		"dislikes": ["Dust", "Bad manners"],
		"secret": "She practices cleaning magic.",
		"bg_color_code": "#9932CC",
		
		"portraits": {
			"portrait": preload("res://scenes/characters/Kiyomi/Kiyomi_Portrait.png"),
			"default": preload("res://scenes/characters/Kiyomi/Kiyomi_Default.png"),
			#"happy": preload("res://scenes/characters/Kiyomi/Kiyomi_happy.png"),
			#"sad": preload("res://scenes/characters/Kiyomi/Kiyomi_sad.png"),
			#"surprised": preload("res://scenes/characters/Kiyomi/Kiyomi_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"afternoon": {
				"has_place_lie": true,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			}
		},
		
		"secret_info": {
			"sosuke_knows_secret": false,
			"sosuke_has_secret_hints": false,
			"sosuke_knows_cake": false,
			"ate_cake": true,
			"hint_1": false,
			"hint_2": false,
			"hint_3": false,
			"hint_4": false
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
			"portrait": preload("res://scenes/characters/Mikan/Mikan_default.png"),
			"default": preload("res://scenes/characters/Mikan/Mikan_default.png"),
			#"happy": preload("res://scenes/characters/Mikan/Mikan_happy.png"),
			#"sad": preload("res://scenes/characters/Mikan/Mikan_sad.png"),
			#"surprised": preload("res://scenes/characters/Mikan/Mikan_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"afternoon": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			}
		},
		
		"secret_info": {
			"sosuke_knows_secret": false,
			"sosuke_has_secret_hints": false,
			"sosuke_knows_cake": false,
			"ate_cake": true,
			"hint_1": false,
			"hint_2": false,
			"hint_3": false,
			"hint_4": false
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
			"portrait": preload("res://scenes/characters/Pii-Chan/Pii-Chan_default.png"),
			"default": preload("res://scenes/characters/Pii-Chan/Pii-Chan_default.png"),
			#"happy": preload("res://scenes/characters/Pii-Chan/Pii-Chan_happy.png"),
			#"sad": preload("res://scenes/characters/Pii-Chan/Pii-Chan_sad.png"),
			#"surprised": preload("res://scenes/characters/Pii-Chan/Pii-Chan_surprised.png")
		},
		
		"schedule": {
			"morning": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"afternoon": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
			},
			"evening": {
				"has_place_lie": false,
				"sosuke_thinks_place": "???",
				"sosuke_thinks_activity": "???"
				}
			},
			
			"secret_info": {
				"sosuke_knows_secret": false,
				"sosuke_has_secret_hints": false,
				"sosuke_knows_cake": false,
				"ate_cake": false,
				"hint_1": false,
				"hint_2": false,
				"hint_3": false,
				"hint_4": false
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

# Call this everytime Sosuke reveals a hint
func check_if_all_hints(character: String):
	if get_flag(character + "/secret_info/sosuke_has_secret_hints"):
		return
	
	var h1 = get_flag(character + "/secret_info/hint_1")
	var h2 = get_flag(character + "/secret_info/hint_2")
	var h3 = get_flag(character + "/secret_info/hint_3")
	var h4 = get_flag(character + "/secret_info/hint_4")
	# If all hint flags are "true" set that Sosuke knows all the hints
	if h1 and h2 and h3 and h4:
		set_flag((character + "secret_info/sosuke_has_secret_hints"), true)
