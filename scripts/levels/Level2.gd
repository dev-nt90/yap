extends Node2D

@export var level_par_time : String
@export var level_name : String

func _ready():
    $BackgroundMusic/ObservingTheStar.play()
    SceneManager.set_current_scene_path("res://scenes/levels/Level2.tscn")

func get_par_time():
    return level_par_time

func get_level_name():
    return level_name
