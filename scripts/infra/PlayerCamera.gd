extends Camera2D

var level_name : String

func _ready():
    var scene_root = get_node("/root/SceneManager/CurrentScene/SceneRoot")
    if scene_root != null:
        level_name = get_node("/root/SceneManager/CurrentScene/SceneRoot").get_level_name()
    else:
        # HACK: if we try to play/debug the current scene, we are not setting the current level as the current scene, which means 
        # the scene root will not be found. This ugly thing lets us get around that. Truthfully this should probably be a service.
        level_name = get_parent().get_parent().get_level_name()
    $LevelNameLabel.text = level_name

func _process(_delta):
    # HACK: for some reason, on scene reload the camera may not be set as the current camera
    if not is_current():
        print_debug("player camera not current! setting current")
        make_current()
