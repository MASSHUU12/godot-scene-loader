extends Node2D


func _ready() -> void:
	SceneLoader.set_configuration({
		"scene1": "res://example/scenes/scene1/Scene1.tscn"
	})


func _on_start_pressed() -> void:
	SceneLoader.load_scene(self, "scene1")


func _on_exit_pressed() -> void:
	get_tree().quit()
