extends Node2D

var selected_child: Node2D = null

var level1 = preload("res://levels/World0/Level01.tscn")
var level2 = preload("res://levels/World0/Level02.tscn")
var level3 = preload("res://levels/World0/Level03.tscn")
var level4 = preload("res://levels/World0/Level04.tscn")
var test_level = preload("res://levels/LevelTest.tscn")

var level_index = 1
var crates_on_level = -1
var current_crates_on_exit = 0

var levels = [test_level, level1, level2, level3, level4]
var map_states: Array[Dictionary] = []
var current_level: Node2D

func load_level(levelScene: PackedScene):
	var level = levelScene.instantiate()
	var robots = level.get_node("Robots").get_children()
	map_states.clear()
	
	for robot in robots:
		robot.connect("will_move", self._player_moved_robot)
		
	current_crates_on_exit = 0
	crates_on_level = level.get_node("Crates").get_child_count()
	
	var crates = level.get_node("Crates").get_children()
	for crate in crates:
		crate.connect("on_exit", self._on_crate_entered_exit)
		
	var map_center_point = level.get_node("MapCenter")
	level.position = -1 * map_center_point.position
	
	var ScreenTransition = $Camera2D/CanvasLayer/AspectRatioContainer/ScreenTransition as ColorRect
	
	if current_level:
		var unload_tween = get_tree().create_tween()
		unload_tween.set_ease(Tween.EASE_IN_OUT)
		unload_tween.tween_property(ScreenTransition.material, "shader_parameter/circle_size", 0, 0.3)
		await unload_tween.finished
		unload_level()
		
	var current_level_label = $Camera2D/CanvasLayer/MarginContainer2/Label as Label
	
	var levelMetadataComponent: LevelMetadataComponent = level.get_node("LevelMetadataComponent") if level.has_node("LevelMetadataComponent") else null
	levelMetadataComponent.set_label_text(current_level_label)
	
	current_level = level
	add_child(level)
	
	var load_tween = get_tree().create_tween()
	load_tween.set_ease(Tween.EASE_IN_OUT)
	load_tween.tween_property(ScreenTransition.material, "shader_parameter/circle_size", 1, 0.3)
	await load_tween.finished
	
	return level
	
func unload_level():
	var crates = current_level.get_node("Crates").get_children()
	for crate in crates:
		crate.disconnect("on_exit", self._on_crate_entered_exit)
		
	remove_child(current_level)
	current_level.queue_free()
	
var is_swiping = false
var touchStartPosition = Vector2.ZERO	
var touch_start_time = 0
const minSwipeDistance = 100; 

func create_custom_swipe_event(direction: types.Direction):
	var event = InputEventScreenSwipe.new()
	event.direction = direction
	return event
	
func swipe_start(event: InputEventScreenTouch):
	touch_start_time = Time.get_unix_time_from_system()
	touchStartPosition = event.position
	
func swipe_end(event: InputEventScreenTouch):
	var delta = event.position - touchStartPosition
	var time = Time.get_unix_time_from_system() - touch_start_time
	
	if time > 0.25:
		return
		
	
	var swipe_input_event
	if abs(delta.x) >= minSwipeDistance || abs(delta.y) >= minSwipeDistance:
		if abs(delta.x) > abs(delta.y):
			if delta.x > 0:
				swipe_input_event = create_custom_swipe_event(types.Direction.right)
			else:
				swipe_input_event = create_custom_swipe_event(types.Direction.left)
		else: 
			if delta.y > 0:
				swipe_input_event = create_custom_swipe_event(types.Direction.down)
			else:
				swipe_input_event = create_custom_swipe_event(types.Direction.up)
		
	if swipe_input_event:
		Input.parse_input_event(swipe_input_event)

var prev_drag_position := Vector2.ZERO
var delta := Vector2.ZERO
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
		
func _ready():
	var screen_size = DisplayServer.screen_get_size()
	
	load_level(levels[level_index])
	
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		revert_action()
		
func _player_moved_robot():
	save_current_state()

func _on_crate_entered_exit():
	current_crates_on_exit += 1
	
	if current_crates_on_exit == crates_on_level:
		level_index += 1
		load_level(levels[level_index])
		
func revert_action():
	var index = map_states.size() - 1
	if index < 0:
		return
		
	var state = map_states[index]
	map_states.remove_at(index)
	var nodes: Array[Node] = get_tree().get_nodes_in_group("save_state")
	for node in nodes:
		if !node is Node2D:
			continue
			
		var id = node.get_instance_id()
		if !node.has_node("PushLayerComponent"):
			# TODO - I should add some error here
			continue

		var pushLayerComponent: PushLayerComponent = node.get_node("PushLayerComponent")
		pushLayerComponent.tween_position(state[str(id)] * constants.TILE_SIZE) 

func save_current_state():
	var state = MapState.new()
	
	var nodes: Array[Node] = get_tree().get_nodes_in_group("save_state")
	for node in nodes:
		if !node is Node2D:
			continue
			
		state.save_entity_position(node)
		
	map_states.append(state.build())

var revert_timer_timeout = 0.5

func _on_button_button_down():
	revert_action()
	$RevertTimer.start(0)
	$RevertTimer.wait_time = 0.2
	
func _on_button_button_up():
	$RevertTimer.stop()
	$RevertTimer.wait_time = revert_timer_timeout

func _on_revert_timer_timeout():
	$RevertTimer.wait_time = 0.2
	revert_action()
