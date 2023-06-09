# autoloaded as GameState

extends Node2D

@export var currently_selected_level := 0
@export var currently_selected_world := 0
@export var unlocked_level := 1

func serialize():
    var serialized = {
        "currently_selected_level": currently_selected_level,
        "currently_selected_world": currently_selected_world,
        "unlocked_level": unlocked_level
    }

    return serialized

func deserialize(data: Dictionary):
    currently_selected_level = data.get("currently_selected_level", 0)
    currently_selected_world = data.get("currently_selected_world", 0)
    unlocked_level = data.get("unlocked_level", 1)
