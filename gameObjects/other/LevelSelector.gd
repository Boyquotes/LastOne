extends Node2D

@export var level_to_load: PackedScene
@export var level_index: int = 10000

@onready var activateComponent: ActivateComponent = $ActivateComponent

signal selected

func _ready():
    activateComponent.deactivate()
    
    var unlocked_level = GameState.unlocked_level
    if unlocked_level >= level_index:
        activateComponent.activate()

func _on_texture_button_pressed():
    emit_signal("selected", level_to_load)
