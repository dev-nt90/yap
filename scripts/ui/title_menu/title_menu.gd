extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
    get_node("ReferenceRect/StartButton").grab_focus()
    
    #https://opengameart.org/content/sirens-in-darkness
    #https://opengameart.org/content/the-charm-68
    get_parent().get_node("BackgroundMusic/TheCharm68").play()
    $OptionsDialogue.hide()

func _on_start_button_pressed():
    get_tree().change_scene_to_file("res://scenes/levels/Level.tscn")
    

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
    if $OptionsDialogue.visible:
        $OptionsDialogue.hide()
    $OptionsDialogue.show()
