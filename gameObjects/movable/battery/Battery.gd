extends Node2D

var base = BaseRobot.new()

var is_on_exit = false

signal on_exit
signal off_exit

func _ready():
	base.initialize(self, types.ROBOT_TYPE.battery)
	
func _on_area_2d_input_event(viewport, event, shape_idx):
	base.handle_select_robot(event)

func push(direction: Vector2):
	return base.push(direction)

func _on_react_area_area_entered(area: Area2D):
	var parent = area.get_parent()
	
	if !"type" in parent:
		return
