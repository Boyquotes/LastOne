extends Node2D

@onready var ScreenTransition = $CanvasLayer/AspectRatioContainer/ScreenTransition
@onready var screenChangerComponent: ScreenChangerComponent = $ScreenChangerComponent

var play_scene = preload("res://screens/Play.tscn")
var world_selector_scene = preload("res://screens/WorldSelector.tscn")

var world_0_levels_node = preload("res://levels/World0/Levels.tscn")

func _ready():
    SaveManager.load_game()
    
    var world_0_levels = world_0_levels_node.instantiate()
    
    add_child(world_0_levels)
    move_child(world_0_levels, 1)
    
    for level_selector in world_0_levels.get_children():
        level_selector.connect("selected", self._on_level_selected)

func _on_level_selected(level: PackedScene):
    var play_scene_instantion = play_scene.instantiate()
    play_scene_instantion.set_initial_level(level)
    
    queue_free()
    
    get_node("/root").add_child(play_scene_instantion)


func _on_button_pressed():
    screenChangerComponent.change_scene(world_selector_scene)
