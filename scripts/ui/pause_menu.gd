extends Control

func _ready():
    # do not show pause menu initially
    hide_all()
    
    # only care about pause menu stuff when the game is paused
    process_mode = Node.PROCESS_MODE_WHEN_PAUSED      

func hide_all(): 
    hide_controls()
    
    hide_popups()
        
    hide()

func hide_controls():
    var controls = get_node("PauseMenuControls").get_children()
    for control in controls:
        control.hide()
        
func hide_popups():
    var popups = get_node("PauseMenuPopups").get_children()
    for popup in popups:
        popup.hide()
        
func any_popups_visible() -> bool:
    var popups_visible = false
    var popups = get_node("PauseMenuPopups").get_children()
    for popup in popups:
        if popup.visible:
            popups_visible = true
            break
    return popups_visible
    
func any_controls_visible() -> bool:
    var controls_visible = false
    var controls = get_node("PauseMenuControls").get_children()
    for control in controls:
        if control.visible:
            controls_visible = true
            break
    return controls_visible

func show_pause_menu():
    show()
    var controls = get_node("PauseMenuControls").get_children()
    for control in controls:
        control.show()
    
# mouse support
# ResumeButton
func _on_resume_button_pressed():
    hide_all()
    get_tree().paused = false
    
    
# RestartLevelButton
func _on_restart_level_button_pressed():
    hide_all()
    get_tree().paused = false # unpause the game, since we had to be paused to enter this function
    SceneManager.reload_scene()
    
# ExitGameButton
func _on_exit_game_button_pressed():
    get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST) # notify all nodes of program termination
    get_tree().quit()

# OptionsButton
func _on_options_button_pressed():
    $PauseMenuPopups/OptionsDialogue.show()
    
# ControlsButton
func _on_controls_button_pressed():
    hide_all()
    $PauseMenuPopups/ControlsPopup.show()

# controller support
# ResumeButton
# BUG: this input is captured in the player script, resulting in a jump on pause screen exit
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

# OptionsButton
func _on_options_button_gui_input(event):
    if event is InputEventJoypadButton:
        if event.button_index == JOY_BUTTON_A and event.pressed:
            _on_options_button_pressed()

# ControlsButton
func _on_controls_button_gui_input(event):
    if event is InputEventJoypadButton:
        if event.button_index == JOY_BUTTON_A and event.pressed:
            _on_controls_button_pressed()
