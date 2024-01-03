extends Camera2D

var level_name : String

func _ready():
    var scene_root = get_node("/root/SceneManager/CurrentScene/SceneRoot")
    if scene_root != null:
        level_name = get_node("/root/SceneManager/CurrentScene/SceneRoot").get_level_name()
    else:
        # BUG: if we try to play the current scene, we are not setting the current level as the current scene, which means 
        # the scene root will not be found. This hacky thing lets us get around that
        level_name = get_parent().get_parent().get_level_name()
    $LevelNameLabel.text = level_name
