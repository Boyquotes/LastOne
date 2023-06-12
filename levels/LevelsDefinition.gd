# autoloaded as LevelsDefinition
extends Node

enum LevelKey {
    LEVEL_0_0,
    LEVEL_0_1,
    LEVEL_0_2,
    LEVEL_0_3,
    LEVEL_0_4,
    LEVEL_1_0,
}

var level_1_0 = Level.new().initialize(
    preload("res://levels/World1/Level0.tscn"),
    [LevelKey.LEVEL_0_4],
)

var level4 = Level.new().initialize(
    preload("res://levels/World0/Level05.tscn"),
    [LevelKey.LEVEL_0_3],
)

var level3 = Level.new().initialize(
    preload("res://levels/World0/Level04.tscn"),
    [LevelKey.LEVEL_0_1],
    level4,
)

var level2 = Level.new().initialize(
    preload("res://levels/World0/Level03.tscn"),
    [LevelKey.LEVEL_0_1],
    level3,
)

var level1 = Level.new().initialize(
    preload("res://levels/World0/Level02.tscn"),
    [LevelKey.LEVEL_0_0],
    level2,
)

var level0 = Level.new().initialize(
    preload("res://levels/World0/Level01.tscn"),
    [],
    level1,
)

var levels: Dictionary = {
    LevelKey.LEVEL_0_0: level0,
    LevelKey.LEVEL_0_1: level1,
    LevelKey.LEVEL_0_2: level2,
    LevelKey.LEVEL_0_3: level3,
    LevelKey.LEVEL_0_4: level4,
    
    LevelKey.LEVEL_1_0: level_1_0,
}
