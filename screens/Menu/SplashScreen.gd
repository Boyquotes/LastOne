extends Node2D

@onready var screenChangerComponent: ScreenChangerComponent = $ScreenChangerComponent

var main_menu_screen = preload("res://screens/Menu/MainMenu.tscn")

const SPLASH_SCREEN_TIME = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    await get_tree().create_timer(SPLASH_SCREEN_TIME).timeout
    screenChangerComponent.change_scene(main_menu_screen)
