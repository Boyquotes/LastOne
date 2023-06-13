extends Node2D

@onready var ScreenTransition = $CanvasLayer/AspectRatioContainer/ScreenTransition
@onready var screenChangerComponent: ScreenChangerComponent = $ScreenChangerComponent

var play_scene = preload("res://screens/Play.tscn")
var world_selector_scene = preload("res://screens/WorldSelector.tscn")

func _ready():
    var world = WorldsDefinition.worlds[GameState.currently_selected_world]
    var world_levels = world.world_scene.instantiate()
    
    add_child(world_levels)
    move_child(world_levels, 1)
    
    for level_selector in world_levels.get_children():
        level_selector.connect("selected", self._on_level_selected)

func _on_level_selected(level_key: LevelsDefinition.LevelKey):
    GameState.currently_selected_level = level_key
    var play_scene_instantion = play_scene.instantiate()
    
    queue_free()
    
    get_node("/root").add_child(play_scene_instantion)


func _on_button_pressed():
    screenChangerComponent.change_scene(world_selector_scene)
