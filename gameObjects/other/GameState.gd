extends Node2D

@export var current_level := 0
@export var unlocked_levels := 1

func serialize():
    var serialized = {
        "current_level": current_level,
        "unlocked_levels": unlocked_levels
    }

    return serialized

func deserialize(data: Dictionary):
    current_level = data.get("current_level", 0)
    unlocked_levels = data.get("unlocked_levels", 1)
