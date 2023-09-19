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

You can configure the extension via the `SceneLoader.set_configuration(_scenes, _path_to_progress_bar, _loading_screen)` function.

### \_scenes

Variable accepting `dictionary` storing aliases to scenes in the form of `name-path`, for example:

```json
{
	"scene1": "res://example/scenes/scene1/Scene1.tscn",
	"scene2": "res://example/scenes/scene2/Scene2.tscn",
	"main_menu": "res://example/MainMenu.tscn"
}
```

That way you don't have to use paths and when the path changes you just have to change it in one place.

### \_path_to_progress_bar

The path to the `progress bar` in the `loading screen`, if you pass it, the progress bar will be updated with the current loading status.

### \_loading_screen

If you don't want to use the default built-in loading screen, you can create your own and pass the path to it in the configuration.

The custom loading screen must always call the `safe_to_load` signal because `SceneLoader` will wait to load the scene until this signal is transmitted.

With this signal, you can start loading a new scene only when the game is ready for it (for example, when the loading screen manages to appear and cover everything).

## Usage

To switch between scenes using the loading screen, just use the `SceneLoder.load_scene()` function.

The first argument will always be the `self` keyword, while the second argument can be the `alias` of the scene, or the `path` to it, for example:

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

## License

Licensed under [MIT license](./LICENSE).
