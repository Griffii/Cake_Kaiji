extends Control

var selected_character: String
@onready var current_character = get_node("/root/" + selected_character)

func _ready() -> void:
	for child in %Character_Grid.get_children():
		if child.has_signal("character_changed_to"):
			child.connect("character_changed_to", Callable(self, "_on_character_change"))
	
	refresh_schedule()
	highlight_character()

func refresh_schedule():
	if selected_character == "":
		%Character_Name_Label.text = "^ Pick a character ^"
		
		%Morning_Place.text = ""
		%Morning_Activity.text = ""
		%Afternoon_Place.text = ""
		%Afternoon_Activity.text = ""
		%Evening_Place.text = ""
		%Evening_Activity.text = ""
	
	
	if CharacterData.characters.has(selected_character):
		var char_data = CharacterData.characters[selected_character]
		var schedule = char_data.get("schedule", {})
		
		# Set Name Label
		%Character_Name_Label.text = char_data.character_name
		var char_color = char_data.bg_color_code
		%Character_Name_Label.add_theme_color_override("font_color", char_color)
		
		
		# Fit Morning labels
		_fit_text_to_label(%Morning_Place, schedule.get("morning", {}).get("sosuke_thinks_place", ""), 375)
		_fit_text_to_label(%Morning_Activity, schedule.get("morning", {}).get("sosuke_thinks_activity", ""), 375)
		
		# Fit Afternoon labels
		_fit_text_to_label(%Afternoon_Place, schedule.get("afternoon", {}).get("sosuke_thinks_place", ""), 375)
		_fit_text_to_label(%Afternoon_Activity, schedule.get("afternoon", {}).get("sosuke_thinks_activity", ""), 375)
		
		# Fit Evening labels
		_fit_text_to_label(%Evening_Place, schedule.get("evening", {}).get("sosuke_thinks_place", ""), 375)
		_fit_text_to_label(%Evening_Activity, schedule.get("evening", {}).get("sosuke_thinks_activity", ""), 375)
	else:
		push_warning("Character not found in CharacterData: " + selected_character)

func highlight_character():
	for child in %Character_Grid.get_children():
		if child.name.to_lower() == selected_character.to_lower():
			child.modulate = Color(1, 1, 1)
		else:
			child.modulate = Color(0.5, 0.5, 0.5)

func _fit_text_to_label(label: Label, text: String, max_width: float, base_size: int = 32, min_size: int = 8):
	if text == "":
		label.text = ""
		return
		
	var font = label.get_theme_font("font")
	var font_size = base_size
	
	# Reduce font size until text fits or min size is reached
	while font and font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > max_width and font_size > min_size:
		font_size -= 1
		
	# Apply final settings
	label.add_theme_font_size_override("font_size", font_size)
	label.text = text


func _on_character_change(new_char: String):
	selected_character = new_char
	refresh_schedule()
	highlight_character()
