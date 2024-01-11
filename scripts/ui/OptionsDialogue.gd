extends Control

const RESOLUTION_OPTIONS = [
    "1280x720",
    "1920x1080"
]

func _ready():
    $CloseOptionsButton.grab_focus()
    for option in RESOLUTION_OPTIONS: # TODO: need to save/load previously saved settings
        $ResolutionOptionButton.add_item(option)
    
func _on_close_options_button_pressed(): 
    # TODO: re-test after refactor
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
    hide()

func _on_close_options_button_gui_input(event):
    if event is InputEventJoypadButton:
        if (event.button_index == JOY_BUTTON_A) and event.pressed:
            _on_close_options_button_pressed()

func _on_resolution_option_button_item_selected(index):
    # parse the selected resolution 
    var selected_resolution = RESOLUTION_OPTIONS[index]
    var vals = selected_resolution.split("x", false, 2)
    
    # set the window size
    var width = int(vals[0])
    var height = int(vals[1])
    get_window().set_size(Vector2i(width, height))
    
    # re-center the screen
    var center_screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
    var window_size = get_window().get_size_with_decorations()
    get_window().set_position(center_screen - window_size/2)
    
    # TODO: The above code only changes the size of the viewport but does not adjust the rendered content itself.
    # To do that, it _appears_ we need to adjust the content scaling factor.
    # see: https://github.com/godotengine/godot-demo-projects/tree/master/gui/multiple_resolutions
