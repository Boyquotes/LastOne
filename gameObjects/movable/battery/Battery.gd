extends Node2D

var is_on_exit = false

signal on_exit
signal off_exit

func _on_react_area_area_entered(area: Area2D):
    var parent = area.get_parent()
    
    if !"type" in parent:
        return
