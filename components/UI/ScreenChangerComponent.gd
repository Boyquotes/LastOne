extends Node2D
class_name ScreenChangerComponent

signal change_scene_requested(newScene: PackedScene)

func change_scene(newScene: PackedScene):
    emit_signal("change_scene_requested", newScene)
