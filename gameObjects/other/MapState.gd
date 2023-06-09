extends Node
class_name MapState

var state: Dictionary = {};

func save_entity_position(entity: Node2D):
    var id = entity.get_instance_id()
    var position = entity.position / constants.TILE_SIZE
    
    state[str(id)] = position

func build() -> Dictionary:
    return state
