extends Node2D

func _ready():
  SaveManager.load_game()
  update_label()

func _on_button_button_down():
  SaveManager.save_game()

func _on_button_2_button_down():
  SaveManager.load_game()
  update_label()

func _on_button_3_button_down():
  GameState.current_level += 1
  update_label()

func update_label():
  $CanvasLayer/Label.text = "Current Level: %d" % GameState.current_level
