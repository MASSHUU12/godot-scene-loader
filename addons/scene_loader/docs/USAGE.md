# Usage

To switch between scenes using the loading screen,
just use the `SceneLoder.load_scene()` function.

The first argument will be the reference to the scene you want to unload,
while the second argument can be the **alias** of the scene,
or the **path** to it, for example:

```gd
// Using alias
SceneLoader.load_scene(self, "scene1");
// Using path
SceneLoader.load_scene(self, "res://example/scenes/scene1/Scene1.tscn");
```

## Configuring the extension

You can configure the extension via the
`set_configuration(config: Dictionary)` function.

You can configure the following options:

### scenes

Accepts **dictionary** storing aliases to scenes in the form of **name-path**,
for example:

```json
{
	"scene1": "res://example/scenes/scene1/Scene1.tscn",
	"scene2": "res://example/scenes/scene2/Scene2.tscn",
	"main_menu": "res://example/MainMenu.tscn"
}
```

That way you don't have to use paths and when the path changes
you just have to change it in one place.

### path_to_progress_bar

The path to the **progress bar** in the **loading screen**, if you pass it,
the progress bar will be updated with the current loading status.

### loading_screen

If you don't want to use the default built-in loading screen,
you can create your own and pass the path to it in the configuration.

You can find more information [here](#creating-custom-loading-screen)

## Creating custom loading screen

The custom loading screen must always call the `safe_to_load` signal
because `SceneLoader` will wait to load the scene until this signal is emitted.

With this signal, you can start loading a new scene only
when the game is ready for it (for example,
when the loading screen manages to appear and cover everything).

`SceneLoader` emits `loading_finished` signal.
This signal will be called when the scene is loaded,
so you know when to hide the loading screen or when to perform other actions.
