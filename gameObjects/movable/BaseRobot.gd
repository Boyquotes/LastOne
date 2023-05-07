extends Node
class_name BaseRobot

signal robot_selected
signal robot_moved

var robot_type: types.ROBOT_TYPE
var animation_speed = 8
var parent: Node2D
var is_selected: bool = false
var is_moving: bool = false

func initialize(_parent: Node2D, _type: types.ROBOT_TYPE):
	robot_type = _type
	parent = _parent
	
func set_is_selected(new_value: bool):
	is_selected = true
	
func handle_select_robot(event):
	if !(event is InputEventScreenTouch) || event.pressed == true:
		return
		
	emit_signal("robot_selected", parent, robot_type)

func tween_position(new_position: Vector2):
	var tween = parent.create_tween()
	tween.tween_property(parent, "position", new_position, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
	is_moving = true
	tween.tween_callback(self.finish_tween)
	
	return

func finish_tween():
	is_moving = false
	emit_signal("robot_moved")

func push(direction: Vector2):
	if is_moving:
		return
		
	var ray_cast = parent.get_node("RayCast2D")
	ray_cast.target_position = direction * constants.TILE_SIZE
	ray_cast.force_raycast_update()
	
	var collider = ray_cast.get_collider()
	if !collider && direction != Vector2.ZERO:
		tween_position(parent.position + direction * constants.TILE_SIZE)
		return true
		
	
	if collider:
		var collision_shape = collider.get_node("CollisionShape2D")
		# hacky because for some reason disabling collision shape doesnt work properly with raycasts
		if collision_shape && collision_shape.disabled:
			tween_position(parent.position + direction * constants.TILE_SIZE)	
			return true	
		
		var has_push = collider.get_parent().has_method('push')
		
		if collider.has_node("PushLayerComponent"):
			return false
		
		var colliderPushLayerComponent: PushLayerComponent = collider.get_node("PushLayerComponent")

		var same_layer = colliderPushLayerComponent.push_layer == parent.get_node("PushLayerComponent").push_layer
		
		# if collider is not on the same level as robot we dont push it.
		if !same_layer:
			tween_position(parent.position + direction * constants.TILE_SIZE)
			return true
		
		var was_pushed = has_push && collider.get_parent().push(direction)
		if was_pushed:
			tween_position(parent.position + direction * constants.TILE_SIZE)
		return was_pushed
