extends Control

func _ready():
    $TitleMenuUi/StartButton.grab_focus()
    
    #TODO: need to credit open art sources
    #https://opengameart.org/content/sirens-in-darkness
    #https://opengameart.org/content/the-charm-68
    $BackgroundMusic/TheCharm68.play()
    $TitleMenuUi/OptionsDialogue.hide()

func _on_start_button_pressed():
    $BackgroundMusic/TheCharm68.stop()
    SceneManager.go_to_next_scene()
    
func _on_start_button_gui_input(event):
    if event is InputEventJoypadButton:
        if event.button_index == JOY_BUTTON_A and event.pressed:
            _on_start_button_pressed()

func _on_exit_button_pressed():
    get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST) # notify all nodes of program termination
    get_tree().quit()

func _on_exit_button_gui_input(event):
    if event is InputEventJoypadButton:
        if event.button_index == JOY_BUTTON_A and event.pressed:
            _on_exit_button_pressed()

func _on_options_button_pressed():
    if $TitleMenuUi/OptionsDialogue.visible:
        $TitleMenuUi/OptionsDialogue.hide()
    else:
        $TitleMenuUi/OptionsDialogue.show()

func _on_options_button_gui_input(event):
    if event is InputEventJoypadButton:
        if event.button_index == JOY_BUTTON_A and event.pressed:
            _on_options_button_pressed()
