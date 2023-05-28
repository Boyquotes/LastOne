extends Camera2D

func animate_according_to_robot_movement(direction: types.Direction):
  if direction == types.Direction.up:
    $AnimationPlayer.play("move_up")
  elif direction == types.Direction.down:
    $AnimationPlayer.play("move_down")
  elif direction == types.Direction.left:
    $AnimationPlayer.play("move_left")
  elif direction == types.Direction.right:
    $AnimationPlayer.play("move_right")
