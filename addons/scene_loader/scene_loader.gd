@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("SceneLoader", "res://addons/scene_loader/autoloads/scene_loader.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("SceneLoader")
