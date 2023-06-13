extends Control

@onready var main_container = $CanvasLayer/VBoxContainer/HFlowContainer

var show = false:
    set(val):
        show = val
        self.on_show_changed()

func on_show_changed():
    main_container.visible = show

func _ready():
    main_container.visible = false

func _on_button_pressed():
    GameState.__reset_game_state()
    get_tree().reload_current_scene()

func _on_reload_game_pressed():
    get_tree().reload_current_scene()

func _on_toggle_pressed():
    show = !show
