extends Camera2D

func _process(_delta):
    # HACK: for some reason, on scene reload the camera may not be set as the current camera
    if not is_current():
        print_debug("player camera not current! setting current")
        make_current()
