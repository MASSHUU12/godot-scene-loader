extends Control


func _ready() -> void:
	SceneLoader.set_configuration({
		"scenes": {
			"scene1": "res://example/scenes/scene1/Scene1.tscn",
			"scene2": "res://example/scenes/scene2/Scene2.tscn",
			"main_menu": "res://example/MainMenu.tscn"
		},
		"path_to_progress_bar": "Container/ProgressBar",
		"loading_screen": "res://example/loading_screen/LoadingScreen.tscn"
	})


func _on_start_pressed() -> void:
	SceneLoader.load_scene(self, "scene1")


func _on_exit_pressed() -> void:
	get_tree().quit()
