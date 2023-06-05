extends Node2D
class_name ActivateComponent

@export var initial_color: Color
@export var active_color: Color
@export var sprite: Sprite2D 

func _ready():
    sprite.modulate = initial_color

func activate():
    var tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(sprite, 'modulate', active_color, 0.2)
        
func deactivate():
    var tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(sprite, 'modulate', initial_color, 0.2)
