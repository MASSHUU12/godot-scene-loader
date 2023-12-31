<div align="center">
	<h3>Godot Scene Loader</h3>
	<p />
	<p>Basic scene loader for Godot 4 with support for loading screens.</p>
</div>

## Features

-   Scene Loader singleton
-   Default loading screen
-   Support for custom loading screens
-   Support for global dictionary with scenes, so you don't have to use paths

## Configuring the extension

> Note: It is best to set the configuration at the beginning of the program, for example, in the main menu, or in another master scene.

You can configure the extension via the `set_configuration(config: Dictionary)` function.

You can configure the following options:

### scenes

Accepts `dictionary` storing aliases to scenes in the form of `name-path`, for example:

```json
{
	"scene1": "res://example/scenes/scene1/Scene1.tscn",
	"scene2": "res://example/scenes/scene2/Scene2.tscn",
	"main_menu": "res://example/MainMenu.tscn"
}
```

That way you don't have to use paths and when the path changes you just have to change it in one place.

### path_to_progress_bar

The path to the `progress bar` in the `loading screen`, if you pass it, the progress bar will be updated with the current loading status.

### loading_screen

If you don't want to use the default built-in loading screen, you can create your own and pass the path to it in the configuration.

You can find more information [here](#creating-custom-loading-screen)

## Creating custom loading screen

The custom loading screen must always call the `safe_to_load` signal because `SceneLoader` will wait to load the scene until this signal is transmitted.

With this signal, you can start loading a new scene only when the game is ready for it (for example, when the loading screen manages to appear and cover everything).

In addition, your loading screen must include the `loading_finished` signal.
This signal will be called by the extension when the scene is loaded, so you know when to hide the loading screen or when to perform other actions.

## Usage

To switch between scenes using the loading screen, just use the `SceneLoder.load_scene()` function.

The first argument will be the reference to the scene you want to unload, while the second argument can be the `alias` of the scene, or the `path` to it, for example:

```ts
// Using alias
SceneLoader.load_scene(self, "scene1");
// Using path
SceneLoader.load_scene(self, "res://example/scenes/scene1/Scene1.tscn");
```

## Debugging via VSCode

The extension has a ready-made configuration for debugging the project via `VSCode`, all you need to do is in the [launch.json](.vscode/launch.json) file in `program` to pass the correct `path` to the `Godot executable` file.
After that, all you have to do is press `F5` to launch the entire project.

You can also use this to launch your entire project.

This will only work for pure projects in GDScript.

### Debugging C# projects

If you want to debug projects written with `C#` you need to create a `tasks.json` file in the `.vscode` folder.

The file should look like this:

```json
{
	"version": "2.0.0",
	"tasks": [
		{
			"type": "dotnet",
			"task": "build",
			"problemMatcher": ["$msCompile"],
			"group": {
				"kind": "build",
				"isDefault": true
			},
			"label": "build"
		}
	]
}
```

You also need to slightly change the `launch.json` file.
Just add `"preLaunchTask": "build",` to the configuration.

## License

Licensed under [MIT license](./LICENSE).
