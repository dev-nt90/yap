extends Node2D

@export var next_level : PackedScene
@export var level_par_time : String
@export var level_name : String

func _ready():
    $BackgroundMusic/ObservingTheStar.play()

func get_next_level():
    return next_level

func get_par_time():
    return level_par_time

func get_level_name():
    return level_name
