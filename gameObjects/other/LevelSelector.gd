extends Node2D

@export var level_key: LevelsDefinition.LevelKey
@onready var activateComponent: ActivateComponent = $ActivateComponent

signal selected

var level: Level = null

func _ready():
    activateComponent.deactivate()
    level = LevelsDefinition.levels[level_key]
    
    var unlocked_level = GameState.unlocked_level
    if unlocked_level >= level.unlockable_index:
        activateComponent.activate()

func _on_texture_button_pressed():
    emit_signal("selected", level_key)
