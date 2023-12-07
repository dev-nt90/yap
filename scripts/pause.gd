extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    if Input.is_action_just_pressed("pause"):
        get_tree().paused = !get_tree().paused
        
        var is_paused = get_tree().paused
        var pause_menu = get_node("/root/SceneRoot/HUD/PauseMenu") # TODO: referencing the pause menu directly sucks; refactor this 
        
        # did we just pause or unpause?
        if not is_paused:
            pause_menu.hide()
        else:
            pause_menu.show()
            get_node("/root/SceneRoot/HUD/PauseMenu/ResumeButton").grab_focus() # TODO: referencing the pause menu directly sucks; refactor this 
