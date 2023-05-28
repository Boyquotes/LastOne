extends Node2D

var direction = Vector2.ZERO
var timeout = 0.5

var currently_controlled = false
var should_move = false
var can_move = true

var current_direction: types.Direction = -1

signal will_move
# player started moving robot
signal player_started_robot_move

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

func _physics_process(_delta):
  if $PushLayerComponent.is_moving:
    return
    
  if should_move && (current_direction == types.Direction.up || current_direction == types.Direction.down):
    if current_direction == types.Direction.up:
      moved_up()
    else:
      moved_down()
    currently_controlled = true
  else:
    currently_controlled = false
    
  if should_move && can_move && can_be_controlled():
    if current_direction == types.Direction.up:
      direction.y = -1
      
    if current_direction == types.Direction.down:
      direction.y = 1
    
  if direction != Vector2.ZERO:
    can_move = false
    $MovementTimer.wait_time = timeout
    $MovementTimer.start()
    
    var has_moved = $PushLayerComponent.push(direction)
    if !has_moved:
      emit_signal("player_started_robot_move", current_direction)

    emit_signal("will_move")
    
  direction = Vector2.ZERO

func moved_up():
  $Sprite2D.texture.region = Rect2(16, 32, 16, 16)

func moved_down():
  $Sprite2D.texture.region = Rect2(0, 32, 16, 16)
  
func _on_movement_timer_timeout():
  timeout = 0.25
  can_move = true
  
func can_be_controlled() -> bool:
  var nodes = get_tree().get_nodes_in_group("player_controlled")
  var controllable = true
  for node in nodes:
    if !"currently_controlled" in node:
      continue
    
    if node.currently_controlled && node != self:
      controllable = false
      
  return controllable
