extends Node

var scenes: Dictionary = {}
var path_to_progress_bar: String = "Container/ProgressBar"
var loading_screen: Resource  = preload("res://addons/scene_loader/default_loading_screen/DefaultLoadingScreen.tscn")


## Sets the configuration for the scene loader.
##
## Arguments:
## - _scenes: A dictionary containing the scene names and paths.
## - _path_to_progress_bar: The path to the progress bar node in the loading screen.
## - _loading_screen: The path to the loading screen scene.
##
## Returns: None
func set_configuration(_scenes: Dictionary, _path_to_progress_bar := "", _loading_screen := "") -> void:
	scenes = _scenes
	path_to_progress_bar = _path_to_progress_bar

	if _loading_screen != "":
		loading_screen = load(_loading_screen)


## Loads a scene asynchronously and replaces the current scene with it.
##
## Arguments:
## - current_scene: The current scene to be replaced.
## - next_scene: The path to the scene to be loaded.
##
## Returns: None
func load_scene(current_scene: Node, next_scene: String) -> void:
	var loading_screen_instance: Node = initialize_loading_screen()
	var path: String = find_scene_path(next_scene)

	# Load scene
	if ResourceLoader.load_threaded_request(path) != OK:
		printerr("Scene %s does not exist." % path)
		return

	# Wait for loading screen to be ready
	await loading_screen_instance.safe_to_load
	current_scene.queue_free()

	while true:
		var load_progress = []
		var load_status = ResourceLoader.load_threaded_get_status(path, load_progress)

		match load_status:
			0: # THREAD_LOAD_INVALID_RESOURCE
				printerr("Can not load the resource.")
				return
			1: # THREAD_LOAD_IN_PROGRESS
				update_progress_bar(loading_screen_instance, path_to_progress_bar, load_progress[0])
			2: # THREAD_LOAD_FAILED
				printerr("Loading failed.")
				return
			3: # THREAD_LOAD_LOADED
				var next_scene_instance = ResourceLoader.load_threaded_get(path).instantiate()
				get_tree().get_root().call_deferred("add_child", next_scene_instance)
				loading_screen_instance.fade_out_loading_screen()
				return


## Loads a scene asynchronously and adds it to the current scene.
##
## Returns: Loading screen instance
func initialize_loading_screen() -> Node:
	var loading_screen_instance: Node = loading_screen.instantiate()
	get_tree().get_root().call_deferred("add_child", loading_screen_instance)

	return loading_screen_instance


## Finds the path to the scene file.
##
## Arguments:
## - next_scene: The path to the scene to be loaded.
##
## Returns: The path to the scene file.
func find_scene_path(next_scene: String) -> String:
	# Find path to the scene file
	var path: String = scenes[next_scene] if scenes.has(next_scene) else next_scene

	# Validate path
	if not ResourceLoader.exists(path):
		printerr("Scene %s does not exist." % path)
		return ""

	return path


## Updates the progress bar in the loading screen.
##
## Arguments:
## - loading_screen_instance: The loading screen instance.
## - path_to_progress_bar: The path to the progress bar node in the loading screen.
## - load_progress: The progress of the loading process.
##
## Returns: Void
func update_progress_bar(loading_screen_instance: Node, path_to_progress_bar: String, load_progress: int) -> void:
	if path_to_progress_bar != "":
		var progress_bar := loading_screen_instance.get_node(path_to_progress_bar)

		if progress_bar == null:
			printerr("Path to progress bar is invalid.")
		else:
			progress_bar.value = load_progress
