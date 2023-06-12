extends Node
class_name Level

var level_scene: PackedScene
var next_level_definition: Level
var unlock_requirements: Array[LevelsDefinition.LevelKey]

func initialize(
    _level_scene: PackedScene,
    _unlock_requirements: Array[LevelsDefinition.LevelKey],
    _next_level_definition: Level = null
):
    level_scene = _level_scene
    next_level_definition = _next_level_definition
    unlock_requirements = _unlock_requirements
    
    return self
    
func is_unlocked() -> bool:
    var unlock_requirements_length = len(unlock_requirements)
    
    if !unlock_requirements_length:
        return true
    
    var unlock_requirements_count = 0
    
    for finished_level in GameState.finished_levels:
        for requirement in unlock_requirements:
            if finished_level == requirement:
                unlock_requirements_count += 1
        
        if unlock_requirements_length == unlock_requirements_count:
            return true
    
    return false
        
