extends Sprite2D

@export var theme: String
@onready var main_scene = $"../.."

func _on_body_entered(body: Node2D) -> void:
	print("Body entered basket: ", theme)
	main_scene._on_basket_body_entered(body, self)
