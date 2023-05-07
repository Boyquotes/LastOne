extends Node2D

var is_door_opened = false
var battery_area: Area2D = null
var robot_area: Area2D = null
var has_power = false

func _on_area_2d_area_entered(area: Area2D):
	var parent = area.get_parent();
	
	if !"base" in parent:
		return
		
	if !"robot_type" in parent.base:
		return
		
	if parent.base.robot_type == types.ROBOT_TYPE.battery:
		has_power = true
		battery_area = area
		$PadSprite.activate()
		$Button.activate()
		
		var battery = battery_area.get_parent()
		battery.activate()

func _on_area_2d_area_exited(area: Area2D):
	if area == battery_area:
		has_power = false
		$PadSprite.deactivate()
		$Button.deactivate()
		
		var battery = battery_area.get_parent()
		battery.deactivate()

func open_door():
	$DoorSprite.open()
	$DoorSprite/Area2D/CollisionShape2D.disabled = true
	
func close_door():
	$DoorSprite.close()
	$DoorSprite/Area2D/CollisionShape2D.disabled = false

func _on_button_area_entered(area):
	var parent = area.get_parent();
	
	if !"base" in parent:
		return
		
	if !"robot_type" in parent.base:
		return
	
	if !has_power:
		return
		
	if parent.base.robot_type == types.ROBOT_TYPE.horizontal || parent.base.robot_type == types.ROBOT_TYPE.vertical:
		is_door_opened = true
		robot_area = area
		open_door()

func _on_button_area_exited(area):
	if area == battery_area:
		battery_area = null
		is_door_opened = false
		close_door()
