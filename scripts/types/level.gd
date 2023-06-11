extends Node
class_name Level

var level_scene: PackedScene
var next_level_definition: Level
var unlockable_index: int
var index_increment: int

func initialize(
    _level_scene: PackedScene,
    _unlockable_index: int,
    _index_increment: int,
    _next_level_definition: Level = null
):
    level_scene = _level_scene
    next_level_definition = _next_level_definition
    index_increment = _index_increment
    unlockable_index = _unlockable_index
    
    return self
