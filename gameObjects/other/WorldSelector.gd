extends Node2D

@export var world_key: WorldsDefinition.WorldKey
@onready var activateComponent: ActivateComponent = $ActivateComponent

signal selected

var world: World = null

func _ready():
    activateComponent.deactivate()
    world = WorldsDefinition.worlds[world_key]
    
    if world.is_unlocked():
        activateComponent.activate()

func _on_texture_button_pressed():
    emit_signal("selected", world_key)
