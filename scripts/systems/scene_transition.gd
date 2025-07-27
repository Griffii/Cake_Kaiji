extends CanvasLayer

@onready var animation_player = $AnimationPlayer

signal fade_in_finished
signal fade_out_finished

func play_fade_in():
	animation_player.play("fade_in")
	await animation_player.animation_finished
	emit_signal("fade_in_finished")

func play_fade_out():
	animation_player.play("fade_out")
	await animation_player.animation_finished
	emit_signal("fade_out_finished")
