extends Node3D


func _on_previous_scene_pressed() -> void:
	SceneLoader.load_scene(self, "scene1")


func _on_main_menu_pressed() -> void:
	SceneLoader.load_scene(self, "main_menu")
