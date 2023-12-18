extends Control

func _ready():
    $CloseOptionsButton.grab_focus()
    
func _on_close_options_button_pressed(): 
    # BUG: controller support is broken on options close
    # this is due to the fact that we're using the same options control on both the title menu and in-game pause menu
    # so if we try to grab a control on the title menu, that control won't exist in-game, and vice versa
    # there are a few options to fix this:
    # 1a) create a new invisible control which this control can reference and then attempt to find an element to focus on
    # 1b) branch the options control logic based on who is calling this control
    # 2) create separate options components
    #
    # None of these options are great, but it's probably cleanest for #2 to be the path forward, so long
    # as a shared contract for the options data itself is specified for all options controls.
    get_parent().hide()

func _on_close_options_button_gui_input(event):
    if event is InputEventJoypadButton:
        if (event.button_index == JOY_BUTTON_A) and event.pressed:
            _on_close_options_button_pressed()
