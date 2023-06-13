extends Node
class_name World

var world_scene: PackedScene
var unlock_requirements: Array[WorldsDefinition.WorldKey]

func initialize(
    _world_scene: PackedScene,
    _unlock_requirements: Array[WorldsDefinition.WorldKey],
) -> World:
    world_scene = _world_scene
    unlock_requirements = _unlock_requirements

    return self

func is_unlocked() -> bool:
    var unlock_requirements_length = len(unlock_requirements)
    var unlock_requirements_count = 0
    
    if (!unlock_requirements_length):
        return true
    
    for finished_world in GameState.finished_worlds:
        for requirement in unlock_requirements:
            if finished_world == requirement:
                unlock_requirements_count += 1
        
        if unlock_requirements_length == unlock_requirements_count:
            return true
    
    return false
