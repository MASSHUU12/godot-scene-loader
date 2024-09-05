@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("SceneLoader", "/autoloads/scene_loader.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("SceneLoader")
