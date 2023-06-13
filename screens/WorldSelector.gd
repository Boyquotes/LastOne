extends Node2D

@onready var screenChangerComponent: ScreenChangerComponent = $ScreenChangerComponent

var menu_scene = preload("res://screens/Menu/MainMenu.tscn")
var world_scene = preload("res://screens/World.tscn")

func _ready():
    $WorldSelector.connect("selected", _on_world_selected)
    $WorldSelector2.connect("selected", _on_world_selected)
    
func _on_world_selected(world_key: WorldsDefinition.WorldKey):
    GameState.currently_selected_world = world_key
    screenChangerComponent.change_scene(world_scene)

func _on_button_2_pressed():
    screenChangerComponent.change_scene(menu_scene)
