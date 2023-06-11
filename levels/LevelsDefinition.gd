# autoloaded as LevelsDefinition
extends Node

enum LevelKey {
    LEVEL_0_0,
    LEVEL_0_1,
    LEVEL_0_2,
    LEVEL_0_3,
    LEVEL_0_4
}

var level4 = Level.new().initialize(
    preload("res://levels/World0/Level05.tscn"),
    4,
    1,
)

var level3 = Level.new().initialize(
    preload("res://levels/World0/Level04.tscn"),
    3,
    0.5,
    level4,
)

var level2 = Level.new().initialize(
    preload("res://levels/World0/Level03.tscn"),
    3,
    0.5,
    level3,
)

var level1 = Level.new().initialize(
    preload("res://levels/World0/Level02.tscn"),
    2,
    1,
    level2,
)

var level0 = Level.new().initialize(
    preload("res://levels/World0/Level01.tscn"),
    1,
    1,
    level1,
)

var levels: Dictionary = {
    LevelKey.LEVEL_0_0: level0,
    LevelKey.LEVEL_0_1: level1,
    LevelKey.LEVEL_0_2: level2,
    LevelKey.LEVEL_0_3: level3,
    LevelKey.LEVEL_0_4: level4,
}
