extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
    hide()
    process_mode = Node.PROCESS_MODE_WHEN_PAUSED

# TODO: make these buttons generic
# RestartLevelButton
func _on_restart_level_button_pressed():
    hide()
    get_tree().paused = false # unpause the game, since we had to be paused to enter this function
    SceneManager.reload_scene()
    
# ExitGameButton
func _on_exit_game_button_pressed():
    get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST) # notify all nodes of program termination
    get_tree().quit()

# RestartLevelButton
func _on_restart_level_button_gui_input(event):
    if event is InputEventJoypadButton:
        if event.button_index == JOY_BUTTON_A and event.pressed:
            _on_restart_level_button_pressed()

# ExitGameButton
func _on_exit_game_button_gui_input(event):
    if event is InputEventJoypadButton:
        if event.button_index == JOY_BUTTON_A and event.pressed:
            _on_exit_game_button_pressed()
