extends Node2D

@export var level_to_load: PackedScene


signal selected

func _ready():
    pass # Replace with function body.

func _on_texture_button_pressed():
    emit_signal("selected", level_to_load)
