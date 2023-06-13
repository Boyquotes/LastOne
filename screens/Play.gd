extends Node2D

var selected_child: Node2D = null

var crates_on_level = -1
var current_crates_on_exit = 0

var map_states: Array[Dictionary] = []
var current_level: Node2D

var level_definition: Level

func set_level(_level_definition: Level):
    level_definition = _level_definition

func load_level(levelScene: PackedScene):
  var level = levelScene.instantiate()
  var robots = level.get_node("Robots").get_children()
  map_states.clear()
  
  for robot in robots:
    robot.connect("will_move", self._player_moved_robot)
    robot.connect("player_started_robot_move", self._player_started_robot_move)
    
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
    unload_tween.tween_property(ScreenTransition.material, "shader_parameter/circle_size", 1, 1)
    await unload_tween.finished
    unload_level()
    
  var current_level_label = $Camera2D/CanvasLayer/Container/MarginContainer2/Label as Label
  
  var levelMetadataComponent: LevelMetadataComponent = level.get_node("LevelMetadataComponent") if level.has_node("LevelMetadataComponent") else null
  levelMetadataComponent.set_label_text(current_level_label)
  
  current_level = level
  add_child(level)
  
  var load_tween = get_tree().create_tween()
  load_tween.set_ease(Tween.EASE_IN_OUT)
  load_tween.tween_property(ScreenTransition.material, "shader_parameter/circle_size", 0, 1)
  await load_tween.finished
  
  return level
  
func unload_level():
  var crates = current_level.get_node("Crates").get_children()
  for crate in crates:
    crate.disconnect("on_exit", self._on_crate_entered_exit)
    
  remove_child(current_level)
  current_level.queue_free()
  
func _ready():
  level_definition = LevelsDefinition.levels[GameState.currently_selected_level]
  load_level(level_definition.level_scene)
  
func _process(_delta):
  if Input.is_action_just_pressed("ui_accept"):
    revert_action()
    
func _player_moved_robot():
  save_current_state()

func _player_started_robot_move(direction: types.Direction):
  $Camera2D.animate_according_to_robot_movement(direction)

func _on_crate_entered_exit():
  current_crates_on_exit += 1
  
  if current_crates_on_exit == crates_on_level:
    level_definition = level_definition.next_level_definition
    
    if !level_definition.is_unlocked():
        GameState.finished_levels = GameState.finished_levels + [GameState.currently_selected_level]
    
    load_level(level_definition.level_scene)
    
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
