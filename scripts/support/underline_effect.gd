extends RichTextEffect
class_name UnderlineEffect

func _process_custom_fx(char_fx):
	var underline_y = char_fx.position.y + char_fx.size.y
	char_fx.canvas_item.draw_line(
		char_fx.position,
		Vector2(char_fx.position.x + char_fx.size.x, underline_y),
		char_fx.env_color,
		2.0
	)
	return true
