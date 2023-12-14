extends Node

signal scene_started

var next_scene = null

func reload_scene():
    set_scene(next_scene)

func next_level():
    var next_level = get_node("CurrentScene/SceneRoot").get_next_level()
    set_scene(next_level)

func set_scene(scene):
    next_scene = scene
    $TransitionScene.transition()

func _on_transition_scene_transitioned():
    for child in $CurrentScene.get_children():
        child.queue_free()
    
    var instance = next_scene.instantiate()
    instance.name = "SceneRoot" # certain nodes expect the level roots to be named this way
    $CurrentScene.add_child(instance)
    
    emit_signal("scene_started")
