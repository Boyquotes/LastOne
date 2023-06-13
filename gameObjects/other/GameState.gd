# autoloaded as GameState
extends Node2D

@export var currently_selected_level: LevelsDefinition.LevelKey = LevelsDefinition.LevelKey.LEVEL_0_0:
    set (val):
        currently_selected_level = val
        self.save_game()
        
@export var currently_selected_world: WorldsDefinition.WorldKey = WorldsDefinition.WorldKey.WORLD_0:
    set (val):
        currently_selected_world = val
        self.save_game()
        
@export var finished_levels: Array = []:
    set (val):
        finished_levels = val
        self.save_game()
        
@export var finished_worlds: Array = []:
    set (val):
        finished_worlds = val
        self.save_game()

var save_manager

func _ready():
    save_manager = SaveManager.new()

func save_game():
    save_manager.save_game(self.serialize())
    
func load_game():
    var saved_data = save_manager.load_game()
    self.deserialize(saved_data)

func serialize():
    var serialized = {
        "currently_selected_level": currently_selected_level,
        "currently_selected_world": currently_selected_world,
        "finished_levels": finished_levels,
        "finished_worlds": finished_worlds,
    }

    return serialized

func deserialize(data: Dictionary):
    currently_selected_level = data.get("currently_selected_level", 0)
    currently_selected_world = data.get("currently_selected_world", 0)
    finished_levels = data.get("finished_levels", []) as Array[LevelsDefinition.LevelKey]
    finished_worlds = data.get("finished_worlds", []) as Array[WorldsDefinition.WorldKey]

func __reset_game_state():
    currently_selected_level = 0
    currently_selected_world = 0
    finished_levels = []
    finished_worlds = []
