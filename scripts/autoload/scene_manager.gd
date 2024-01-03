extends Node

signal scene_started

var next_scene = null

func load_title_menu():
    set_scene(load("res://scenes/ui/title_menu.tscn"))

func reload_scene():
    set_scene(next_scene)

func load_next_level():
    var next_level = get_node("CurrentScene/SceneRoot").get_next_level()
    set_scene(next_level)

func set_scene(scene):
    next_scene = scene
    $TransitionScene.transition()

func _on_transition_scene_transitioned():
    var current_root = $CurrentScene/SceneRoot
    
    if current_root != null:
        current_root.free()
    
    # TODO: bug here when transitioning from level which was restarted or started from "current scene" editor option
    # maybe need to set the next scene from the main container
    var instance = next_scene.instantiate()
    instance.name = "SceneRoot" # certain nodes expect the level roots to be named this way
    $CurrentScene.add_child(instance)
    
    emit_signal("scene_started")
