extends Node2D

@onready var screenChangerComponent: ScreenChangerComponent = $ScreenChangerComponent
var menu_scene = preload("res:///screens/Menu/MainMenu.tscn")

func _on_button_pressed():
    screenChangerComponent.change_scene(menu_scene)
