@tool
extends Node2D

@export var is_horizontal = false
@export var level_key: LevelsDefinition.LevelKey

@onready var activateComponent: ActivateComponent = $ActivateComponent

var level: Level = null

func _ready():
    activateComponent.deactivate()
    level = LevelsDefinition.levels[level_key]
    
    var unlocked_level = GameState.unlocked_level
    if unlocked_level >= level.unlockable_index:
        activateComponent.activate()

func _process(delta):
    if Engine.is_editor_hint():
        self.update_editor_look()

func update_editor_look():
    if (is_horizontal):
        self.rotation_degrees = 90
    else:
        self.rotation_degrees = 0
