extends Node2D
class_name LevelMetadataComponent;

@export var level_number: int = 0
@export var world_number: int = 0
@export var best_number_of_moves: int = 0
@export var level_title: String = ''

func set_label_text(label: Label):
  label.text = '%02d - %02d' % [world_number, level_number]
