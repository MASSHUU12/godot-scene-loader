extends CanvasLayer

signal safe_to_load

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func fade_out_loading_screen() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	queue_free()
