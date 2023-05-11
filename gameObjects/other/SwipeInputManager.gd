extends Node2D

var prev_drag_position := Vector2.ZERO
var delta := Vector2.ZERO
var is_swiping = false
var current_direction: types.Direction = -1
var prev_direction: types.Direction = -1

func _input(event):
	if event is InputEventScreenDrag && is_swiping:
		delta = event.position - prev_drag_position
		prev_drag_position = event.position
		
	if delta.length() > 5 && is_swiping:
		if abs(delta.x) > abs(delta.y) && (current_direction == -1 || current_direction == types.Direction.left || current_direction == types.Direction.right):
			if delta.x > 0:
				current_direction = types.Direction.right
			elif delta.x < 0:
				current_direction = types.Direction.left
		elif abs(delta.x) < abs(delta.y) && (current_direction == -1 || current_direction == types.Direction.down || current_direction == types.Direction.up): 
			if delta.y > 0:
				current_direction = types.Direction.down
			else:
				current_direction = types.Direction.up
		
		if current_direction != prev_direction:
			var new_event = InputEventTouchJoystickChange.new()
			new_event.direction = current_direction
			Input.parse_input_event(new_event)
			
		prev_direction = current_direction
	
	if event is InputEventScreenTouch && event.pressed == true:
		var new_event = InputEventTouchJoystickStart.new()
		Input.parse_input_event(new_event)
		prev_drag_position = event.position
		is_swiping = true	
	
	if event is InputEventScreenTouch && event.pressed == false:
		var new_event = InputEventTouchJoystickEnd.new()
		Input.parse_input_event(new_event)
		is_swiping = false
		current_direction = -1
		prev_direction = -1
		delta = Vector2.ZERO
