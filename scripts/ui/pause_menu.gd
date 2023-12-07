extends Control

func _ready():
    # do not show pause menu initially
    hide()
    
    # only care about pause menu stuff when the game is paused
    process_mode = Node.PROCESS_MODE_WHEN_PAUSED
    $OptionsDialogue.hide()

# mouse support
# ResumeButton
func _on_resume_button_pressed():
    get_tree().paused = false
    get_node("/root/SceneRoot/HUD/PauseMenu").hide() # TODO: referencing the pause menu directly sucks; refactor this 
    
# RestartLevelButton
func _on_restart_level_button_pressed():
    get_tree().paused = false # unpause the game, since we had to be paused to enter this function
    get_tree().reload_current_scene()
    
# ExitGameButton
func _on_exit_game_button_pressed():
    get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST) # notify all nodes of program termination
    get_tree().quit()

#OptionsButton
func _on_options_button_pressed():
    $OptionsDialogue.show()

# controller support
# ResumeButton
func _on_resume_button_gui_input(event):
    if event is InputEventJoypadButton:
        if event.button_index == JOY_BUTTON_A and event.pressed:
            _on_resume_button_pressed()

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

#OptionsButton
func _on_options_button_gui_input(event):
    if event is InputEventJoypadButton:
        if event.button_index == JOY_BUTTON_A and event.pressed:
            _on_options_button_pressed()
