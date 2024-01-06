extends Node

@onready var pause_menu = get_parent().get_node("HUD/PauseMenu")

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
    # support pausing with typical "pause" buttons
    # KB: ESC; PAD: START (i.e. latest generation version of a start button)
    if Input.is_action_just_pressed("pause"): 
        var is_paused = get_tree().paused
        
        if not is_paused:
            get_tree().paused = true
            pause_menu.show_pause_menu()
            pause_menu.get_node("PauseMenuControls/ResumeButton").grab_focus()
        else:
            handle_pause_menu_navigation()
    
    # support unpausing with the typical "back" button
    # KB: ESC; PAD: Xbox B/Circle/Switch A
    elif Input.is_action_just_pressed("ui_cancel"): 
        handle_pause_menu_navigation()

# TODO: If the pause menu UI gets any layers deeper, we will need to hide the child layer and show the parent layer
# which means tracking the state of which layer we are at.
func handle_pause_menu_navigation():
    if pause_menu.any_popups_visible():
        pause_menu.hide_popups()
        pause_menu.show_pause_menu()
    elif pause_menu.any_controls_visible():
        get_tree().paused = false
        pause_menu.hide_all()
