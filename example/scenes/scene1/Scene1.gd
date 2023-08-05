extends Node3D


func _on_main_menu_pressed() -> void:
	SceneLoader.load_scene(self, "main_menu")


func _on_next_scene_pressed() -> void:
	SceneLoader.load_scene(self, "scene2")
