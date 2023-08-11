extends Node2D


func _ready() -> void:
	SceneLoader.set_configuration({
		"scene1": "res://example/scenes/scene1/Scene1.tscn",
		"scene2": "res://example/scenes/scene2/Scene2.tscn",
		"main_menu": "res://example/MainMenu.tscn"
	},
	"Container/ProgressBar",
	"res://example/loading_screen/LoadingScreen.tscn")


func _on_start_pressed() -> void:
	SceneLoader.load_scene(self, "scene1")


func _on_exit_pressed() -> void:
	get_tree().quit()
