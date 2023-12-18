extends Camera2D

var level_name : String

func _ready():
    level_name = get_node("/root/SceneManager/CurrentScene/SceneRoot").get_level_name()
    $LevelNameLabel.text = level_name

