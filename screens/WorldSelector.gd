extends Node2D

@onready var screenChangerComponent: ScreenChangerComponent = $ScreenChangerComponent

var menu_scene = preload("res://screens/Menu/MainMenu.tscn")
var world_scene = preload("res://screens/World.tscn")

func _on_button_pressed():
    # select world in the save state system
    screenChangerComponent.change_scene(world_scene)
    
func _on_button_2_pressed():
    screenChangerComponent.change_scene(menu_scene)
