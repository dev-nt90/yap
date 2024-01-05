extends Node2D

@export var level_par_time : String
@export var level_name : String

# Called when the node enters the scene tree for the first time.
func _ready():
    #https://opengameart.org/content/chill-arctic-ambient-theme-0
    $BackgroundMusic/AmbientArctic.play()
    SceneManager.set_current_scene_path("res://scenes/levels/Level3.tscn")
    
func get_par_time():
    return level_par_time

func get_level_name():
    return level_name
