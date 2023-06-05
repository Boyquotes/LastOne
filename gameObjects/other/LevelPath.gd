@tool
extends Node2D

@export var is_horizontal = false

func _ready():
    pass # Replace with function body.

func _process(delta):
    if (is_horizontal):
        self.rotation_degrees = 90
    else:
        self.rotation_degrees = 0
