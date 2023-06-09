extends MarginContainer
class_name UIButton

@export var label = "Label"

@onready var LabelContainer: Label = $CenterContainer/MarginContainer/Label

func _ready():
    pass

func _process(_delta: float):
    pass
    # print(LabelContainer)
    # LabelContainer.text = label
