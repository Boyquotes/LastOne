extends Node2D

@onready var ScreenTransition = $CanvasLayer/AspectRatioContainer/ScreenTransition

var play_scene = preload("res://screens/Play.tscn")
var world_0_levels_node = preload("res://levels/World0/Levels.tscn")

func _ready():
    $CanvasLayer.visible = true
    SaveManager.load_game()
    
    var world_0_levels = world_0_levels_node.instantiate()
    
    add_child(world_0_levels)
    move_child(world_0_levels, 1)
    
    for level_selector in world_0_levels.get_children():
        level_selector.connect("selected", self._on_level_selected)

func _on_level_selected(level: PackedScene):
    var play_scene_instantion = play_scene.instantiate()
    play_scene_instantion.set_initial_level(level)
    
    var unload_tween = get_tree().create_tween()
    unload_tween.set_ease(Tween.EASE_IN_OUT)
    unload_tween.tween_property(ScreenTransition.material, "shader_parameter/circle_size", 1, 1)
    await unload_tween.finished
    
    queue_free()
    
    get_node("/root").add_child(play_scene_instantion)
