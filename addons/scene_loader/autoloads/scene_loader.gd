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


func load_scene(current_scene: Node, next_scene: String) -> void:
	var loading_screen_instance: Node = initialize_loading_screen()
	var path: String = find_scene_path(next_scene)

	# Load scene
	if ResourceLoader.load_threaded_request(path) != OK:
		printerr("Scene \"%s\" does not exist." % path)
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
				printerr("[SceneLoader] Can not load the resource.")
				return
			ThreadStatus.IN_PROGRESS:
				update_progress_bar(
					loading_screen_instance,
					path_to_progress_bar,
					load_progress[0]
				)
			ThreadStatus.FAILED:
				loading_finished.emit(ThreadStatus.FAILED)
				printerr("[SceneLoader] Failed to load \"%s\"." % path)
				return
			ThreadStatus.LOADED:
				load_next_scene(path, loading_screen_instance)
				return


func initialize_loading_screen() -> Node:
	var loading_screen_instance: Node = loading_screen.instantiate()
	get_tree().get_root().call_deferred("add_child", loading_screen_instance)

	return loading_screen_instance


func find_scene_path(next_scene: String) -> String:
	# Find path to the scene file
	var path: String = scenes[next_scene] if scenes.has(next_scene) else next_scene

	if not ResourceLoader.exists(path):
		printerr("[SceneLoader] Scene \"%s\" does not exist." % path)
		return ""

	return path


func update_progress_bar(
	loading_screen_instance: Node,
	path_to_progress_bar: String,
	load_progress: int
) -> void:
	if path_to_progress_bar == "":
		return

	var progress_bar := loading_screen_instance.get_node(path_to_progress_bar)

	if progress_bar == null:
		printerr(
			"[SceneLoader] Path to progress bar is invalid: %s."
			% path_to_progress_bar
		)
	else:
		progress_bar.value = load_progress


func load_next_scene(path: String, loading_screen_instance: Node) -> void:
	var next_scene_ins = ResourceLoader.load_threaded_get(path).instantiate()
	get_tree().get_root().call_deferred("add_child", next_scene_ins)
	loading_finished.emit(ThreadStatus.LOADED)
