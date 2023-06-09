extends Node2D

var initial_scene = preload("res:///screens/World.tscn")
var current_scene: Node = null

@onready var ScreenTransition = $CanvasLayer/AspectRatioContainer/ScreenTransition
@onready var ScreenContainer = $ScreenContainer

func _ready():
    $CanvasLayer.visible = true
    load_scene(initial_scene)

func _on_change_scene_requested(new_scene: PackedScene):
    load_scene(new_scene)

func load_scene(scene_node: PackedScene):
    var instance = scene_node.instantiate()
    
    if !instance.has_node("ScreenChangerComponent"):
        assert(false, 'Screen expected to have ScreenChangerComponent defined')
    
    if (current_scene):
        var unload_tween = get_tree().create_tween()
        unload_tween.set_ease(Tween.EASE_IN_OUT)
        unload_tween.tween_property(ScreenTransition.material, "shader_parameter/circle_size", 1, 1)
        await unload_tween.finished
    
        var current_scene_activate_component: ScreenChangerComponent = current_scene.get_node("ScreenChangerComponent")
        current_scene_activate_component.disconnect("change_scene_requested", self._on_change_scene_requested)
        
        ScreenContainer.remove_child(current_scene)
        
    ScreenContainer.add_child(instance)
    current_scene = instance
    var current_scene_activate_component: ScreenChangerComponent = current_scene.get_node("ScreenChangerComponent")
    current_scene_activate_component.connect("change_scene_requested", self._on_change_scene_requested)
    
    var load_tween = get_tree().create_tween()
    load_tween.set_ease(Tween.EASE_IN_OUT)
    load_tween.tween_property(ScreenTransition.material, "shader_parameter/circle_size", 0, 1)
    await load_tween.finished
