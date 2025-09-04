extends Control

@export var character_name: String
@onready var character_ref = CharacterData.characters[character_name]
@onready var portrait_area = %Portrait_Box

var secret_hint_1
var secret_hint_2
var secret_hint_3
var secret_hint_4



func _ready() -> void:
	if character_ref:
		portrait_area.char_name = character_name
		portrait_area.refresh_portrait()
		
		%Name.text = character_ref.character_name
		%Subname.text = character_ref.sub_name
		%Age.text = str("Age: ", character_ref.age)
		
		%Likes.text = "Likes: " + ", ".join(character_ref.likes)
		%Dislikes.text = "Dilikes: " + ", ".join(character_ref.dislikes)
