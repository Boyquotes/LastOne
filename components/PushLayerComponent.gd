extends Node2D
class_name PushLayerComponent

@export var push_layer: int = 0;
@export var animation_speed: int = 8

@export var main_node: Node2D

var is_moving = false

func tween_position(new_position: Vector2):
	var tween = create_tween()
	tween.tween_property(main_node, "position", new_position, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
	is_moving = true
	tween.tween_callback(self.finish_tween)
	
	return

func finish_tween():
	is_moving = false
	emit_signal("robot_moved")

func push(direction: Vector2):
	if is_moving:
		return
		
	$RayCast2D.target_position = direction * constants.TILE_SIZE
	$RayCast2D.force_raycast_update()
	
	var collider = $RayCast2D.get_collider()
	if !collider && direction != Vector2.ZERO:
		tween_position(main_node.position + direction * constants.TILE_SIZE)
		return true
		
	
	if collider:
		var collision_shape = collider.get_node("CollisionShape2D")
		# hacky because for some reason disabling collision shape doesnt work properly with raycasts
		if collision_shape && collision_shape.disabled:
			tween_position(main_node.position + direction * constants.TILE_SIZE)	
			return true	
		
		var has_push = collider.get_parent().has_method('push')
		
		if collider.has_node("PushLayerComponent"):
			return false
		
		var colliderPushLayerComponent: PushLayerComponent = collider.get_node("PushLayerComponent")

		var same_layer = colliderPushLayerComponent.push_layer == push_layer
		
		# if collider is not on the same level as robot we dont push it.
		if !same_layer:
			tween_position(main_node.position + direction * constants.TILE_SIZE)
			return true
		
		var was_pushed = has_push && collider.get_parent().push(direction)
		if was_pushed:
			tween_position(main_node.position + direction * constants.TILE_SIZE)
		return was_pushed
