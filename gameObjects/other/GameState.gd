extends Node2D

@export var current_level := 0

func serialize():
    var serialized = {
        "current_level": current_level
    }

    return serialized

func deserialize(data: Dictionary):
    current_level = data.get("current_level")
