# autoloaded as GameState

extends Node2D

@export var currently_selected_level: LevelsDefinition.LevelKey = LevelsDefinition.LevelKey.LEVEL_0_0
@export var currently_selected_world := 0
@export var finished_levels: Array = []

func serialize():
    var serialized = {
        "currently_selected_level": currently_selected_level,
        "currently_selected_world": currently_selected_world,
        "finished_levels": finished_levels,
    }

    return serialized

func deserialize(data: Dictionary):
    currently_selected_level = data.get("currently_selected_level", 0)
    currently_selected_world = data.get("currently_selected_world", 0)
    finished_levels = data.get("finished_levels", []) as Array[LevelsDefinition.LevelKey]
