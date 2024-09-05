extends Node

signal loading_finished(status: ThreadStatus)

var scenes: Dictionary = {}
var path_to_progress_bar: String = "Container/ProgressBar"
var loading_screen: Resource = preload("uid://du2tuc2v8m2wd")

enum ThreadStatus {
	INVALID_RESOURCE = 0, # THREAD_LOAD_INVALID_RESOURCE
	IN_PROGRESS      = 1, # THREAD_LOAD_IN_PROGRESS
	FAILED           = 2, # THREAD_LOAD_FAILED
	LOADED           = 3  # THREAD_LOAD_LOADED
}

## Sets the configuration for the scene loader.
##
## Arguments:
## - config: A dictionary containing the configuration for the scene loader.
##    - scenes: A dictionary containing the scene names and paths.
##    - path_to_progress_bar: The path to the progress bar node in the loading screen.
##    - loading_screen: The path to the loading screen scene.
##
## Returns: None
func set_configuration(config: Dictionary) -> void:
	if config.has("scenes"):
		scenes = config["scenes"]

	if config.has("path_to_progress_bar"):
		path_to_progress_bar = config["path_to_progress_bar"]

	if config.has("loading_screen"):
		loading_screen = load(config["loading_screen"])

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
			ThreadStatus.INVALID_RESOURCE:
				loading_finished.emit(ThreadStatus.INVALID_RESOURCE)
				printerr("Can not load the resource.")
				return
			ThreadStatus.IN_PROGRESS:
				update_progress_bar(
					loading_screen_instance,
					path_to_progress_bar,
					load_progress[0]
				)
			ThreadStatus.FAILED:
				loading_finished.emit(ThreadStatus.FAILED)
				printerr("Loading failed.")
				return
			ThreadStatus.LOADED:
				load_next_scene(path, loading_screen_instance)
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
## Returns: None
func update_progress_bar(
	loading_screen_instance: Node,
	path_to_progress_bar: String,
	load_progress: int
) -> void:
	if path_to_progress_bar == "":
		return

	var progress_bar := loading_screen_instance.get_node(path_to_progress_bar)

	if progress_bar == null:
		printerr("Path to progress bar is invalid.")
	else:
		progress_bar.value = load_progress

## Loads the next scene.
##
## Arguments:
## - path: The path to the scene file.
## - loading_screen_instance: The loading screen instance.
##
## Returns: None
func load_next_scene(path: String, loading_screen_instance: Node) -> void:
	var next_scene_ins = ResourceLoader.load_threaded_get(path).instantiate()
	get_tree().get_root().call_deferred("add_child", next_scene_ins)
	loading_finished.emit(ThreadStatus.LOADED)
