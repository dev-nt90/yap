# TODO: the mechanism for setting the current/next levels is messy, as it depends on those values being set in the individual levels. come up with cleaner approach
# TODO: background loading: https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html#doc-background-loading
extends Node

signal scene_started

var current_scene = null 

func load_title_menu():
    set_scene(load("res://scenes/ui/title_menu.tscn"))

func reload_scene():
    set_scene(current_scene)
    
# HACK: we use this function to manually set the reference to the current scene such that we can perform level restarts at debug time
func set_current_scene(scene):
    current_scene = scene
    
# called from self, the title menu, and the individual levels
func set_scene(scene):
    current_scene = scene
    $TransitionScene.fade_to_black()

# once the current scene is no longer visible to the player, free it and swap in the new scene
func _on_transition_scene_faded_to_black():
    call_deferred("_deferred_go_to_scene")
    pass
    
func _deferred_go_to_scene():
    # HACK: Currently, starting the game in either the "normal" way or the "debug" way results in two different behaviors. The scene under test is created _outside_
    # of the SceneManager context. This is due to the SceneManager not being the main scene. This is fine until a level reset through death or UI occurs, at which point the 
    # instantiation logic will now have to search through two different spaces in the scene tree, and attempt to handle each in a separate of logic.
    
    # On the first instance of level reload, the following logic will correct this by finding the
    # root of the debug instance, free it, and assign the root to the expected path. Ugly, but it works.
    
    # debug paths: 
    # root/SceneManager/CurrentScene <- empty
    # root/SceneManager/SceneRoot <- not empty

    # normal paths: 
    # root/SceneManager/CurrentScene/SceneRoot
    # root/Main
    
    # BUG: these tests will both fail for the title menu. _probably_ harmless
    var current_root = $CurrentScene/SceneRoot
    var debug_root = get_tree().root.get_node("SceneRoot")
    
    print_debug("current_root %s" % current_root)
    print_debug("debug_root %s" % debug_root)
    
    if current_root != null:
        current_root.free()
    elif debug_root != null:
        debug_root.free()
        
    var instance = current_scene.instantiate()
    instance.name = "SceneRoot" # the level scenes expect the parent of the scene to be named this way
    $CurrentScene.add_child(instance)
    
    emit_signal("scene_started")

func _on_transition_scene_faded_to_normal():
    pass
