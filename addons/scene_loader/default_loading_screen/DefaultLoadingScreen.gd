extends CanvasLayer

signal safe_to_load
signal loading_finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	loading_finished.connect(fade_out_loading_screen)


func fade_out_loading_screen() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	queue_free()
