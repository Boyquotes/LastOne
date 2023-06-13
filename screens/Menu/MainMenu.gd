extends Node2D

@onready var screenChangerComponent: ScreenChangerComponent = $ScreenChangerComponent

var options_screen = preload("res://screens/Menu/Options.tscn")
var world_screen = preload("res://screens/World.tscn")

func _ready():
    pass # Replace with function body.


func _on_play_pressed():
    # TODO - connect with save state - that depends on the fact if the last was world or level scene.
    # Different behaviour when plyer will first time do this
    screenChangerComponent.change_scene(world_screen)

func _on_options_pressed():
    screenChangerComponent.change_scene(options_screen)
