extends Node

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
    if Input.is_action_just_pressed("pause"):
        get_tree().paused = !get_tree().paused
        
        var is_paused = get_tree().paused
        
        var pause_menu =  get_parent().get_node("HUD/PauseMenu")
        
        # did we just pause or unpause?
        if not is_paused:
            pause_menu.hide()
        else:
            pause_menu.show()
            pause_menu.get_node("ResumeButton").grab_focus()
