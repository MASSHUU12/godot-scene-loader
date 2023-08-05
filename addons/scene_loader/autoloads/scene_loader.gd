extends Node

var scenes: Dictionary = {}
var loading_screen: Resource  = preload("res://addons/scene_loader/default_loading_screen/DefaultLoadingScreen.tscn")


func set_configuration(_scenes: Dictionary, _loading_screen: String = "") -> void:
	scenes = _scenes

	if _loading_screen != "":
		loading_screen = load(_loading_screen)


func load_scene(current_scene: Node, next_scene: String) -> void:
	# Create a new loading screen instance
	var loading_screen_instance: Node = loading_screen.instantiate()
	get_tree().get_root().call_deferred("add_child", loading_screen_instance)

	# Find path to the scene file
	var path: String
	if scenes.has(next_scene):
		path = scenes[next_scene]
	else:
		path = next_scene

	var loader

	# Validate path
	if ResourceLoader.exists(path):
		# Load scene
		loader = ResourceLoader.load_threaded_request(path)
	else:
		print("ERR: Scene %s does not exist" % path)
		return

	if loader == null:
		print("ERR: Scene %s does not exist" % path)
		return

	await loading_screen_instance.safe_to_load
	current_scene.queue_free()

	while true:
		var load_progress = []
		var load_status = ResourceLoader.load_threaded_get_status(path, load_progress)

		match load_status:
			0: # THREAD_LOAD_INVALID_RESOURCE
				print("ERR: Can not load the resource")
				return
			1: # THREAD_LOAD_IN_PROGRESS
				loading_screen_instance.get_node("Control/ProgressBar").value = load_progress[0]
			2: # THREAD_LOAD_FAILED
				print("ERR: Loading failed")
				return
			3: # THREAD_LOAD_LOADED
				var next_scene_instance = ResourceLoader.load_threaded_get(path).instantiate()
				get_tree().get_root().call_deferred("add_child", next_scene_instance)
				loading_screen_instance.fade_out_loading_screen()
				return
