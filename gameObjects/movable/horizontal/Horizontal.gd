extends Node2D

signal will_move
signal player_started_robot_move

var should_move = false
var can_move = true
var currently_controlled = false

var timeout = 0.5
var direction := Vector2.ZERO
var current_direction: types.Direction = -1
  
func _input(event):
  if event is InputEventTouchJoystickStart:
    timeout = 0.5
    should_move = true
  
  if event is InputEventTouchJoystickChange:
    current_direction = event.direction
  
  if event is InputEventTouchJoystickEnd:
    should_move = false
    can_move = true
    current_direction = -1

func _physics_process(delta):
  if $PushLayerComponent.is_moving:
    return
    
  if should_move && (current_direction == types.Direction.left || current_direction == types.Direction.right):
    if current_direction == types.Direction.left:
      moved_left()
    else:
      moved_right()
    currently_controlled = true
  else:
    currently_controlled = false
    
  if should_move && can_move:
    if current_direction == types.Direction.left:
      direction.x = -1
      
    if current_direction == types.Direction.right:
      direction.x = 1
    
  if direction != Vector2.ZERO:
    can_move = false
    $MovementTimer.wait_time = timeout
    $MovementTimer.start()
    
    var has_moved = $PushLayerComponent.push(direction)
    if !has_moved:
      emit_signal("player_started_robot_move", current_direction)

    emit_signal("will_move")
  
  direction = Vector2.ZERO

  
func moved_left():
  $Sprite2D.texture.region = Rect2(32, 32, 16, 16)

func moved_right():
  $Sprite2D.texture.region = Rect2(48, 32, 16, 16)

func _on_movement_timer_timeout():
  can_move = true
  timeout = 0.25

func can_be_controlled() -> bool:
  var nodes = get_tree().get_nodes_in_group("player_controlled")
  var controllable = true
  for node in nodes:
    if !"currently_controlled" in node:
      continue
    
    if node.currently_controlled && node != self:
      controllable = false
      
  return controllable
