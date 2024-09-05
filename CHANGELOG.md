# Change Log

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- Project icon.

### Changed

- Plugin now works from custom locations.
- Moved `loading_finished` signal from loading screen to SceneLoader.
- The `loading_finished` signal from now on returns the status
with which the scene loading was completed.
- Improved error messages.
- Moved docs to the plugin folder.

## [1.2.2 - 2024-05-13]

### Fixed

-   #11

## [1.2.1 - 2023-12-01]

### Changed

-   Updated main menu.
-   Updated first scene.
-   Update second scene.

## [1.2.0 - 2023-11-06]

### Added

-   Support for Godot 4.2.

### Changed

-   Default loading screen now have dark background.

## [1.1.0 - 2023-09-19]

### Added

-   Plugin now supports debugging via VScode (you can also use this to debug your whole project, more in README).
-   Documentation for all functions.
-   Extension now emits `loading_finished` signal in loading screen when loading is finished.

### Changed

-   Refactored code.
-   Improved way of configuring the extension.
-   Updated documentation to reflect changes in the extension.
-   Now use of progress bar is fully optional.

## [1.0.1 - 2023-08-11]

### Changed

-   Better display of errors.
-   Code refactoring.
-   Updated the example.
-   Updated the documentation.
