# autoloaded as WorldsDefinition
extends Node

enum WorldKey {
    WORLD_0,
    WORLD_1,
}

var world_0 = World.new().initialize(
    preload("res://levels/World0/Levels.tscn"),
    [],
)

var world_1 = World.new().initialize(
    preload("res://levels/World1/Levels.tscn"),
    [WorldKey.WORLD_0],
)

var worlds: Dictionary = {
    WorldKey.WORLD_0: world_0,
    WorldKey.WORLD_1: world_1,
}
