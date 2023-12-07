extends Node2D

var birb_scene = preload("res://scenes/birb.tscn")
var rng = RandomNumberGenerator.new()

func _on_timer_timeout():
    spawn_birb()
    
func spawn_birb():
    var spawner = rng.randi_range(0, 1) # 0=left, 1=right
    var number_to_spawn = rng.randi_range(1, 5)
    var velocity = rng.randi_range(200, 400)
    
    var birb_position
    var direction
    
    if spawner == 0:
        birb_position = get_node("BirbSpawnPointLeft").position
        direction = 1
    else:
        birb_position = get_node("BirbSpawnPointRight").position
        direction = -1
    
    for i in range(1, number_to_spawn+1):
        
        # create a new non-companion birb 
        var new_birb = birb_scene.instantiate()
        new_birb.set_is_companion(false)
        
        # give the x/y a little offset to spawn and despawn points to
        # make the flight patterns appear more random
        var x_offset = i * 20 * rng.randf_range(.2, .8)
        var y_offset = i * 200 * rng.randf_range(.2, 1.0)
        
        # set the birbs' target to one of the despawn areas
        var despawn_target
        
        if spawner == 0:
            despawn_target = get_node("BirbDespawnAreaRight").position
        else:
            despawn_target = get_node("BirbDespawnAreaLeft").position
            
        despawn_target.y += y_offset/2
        new_birb.set_target(despawn_target)
        
        var new_position = birb_position
        new_position.x += x_offset
        new_position.y -= y_offset
        new_birb.position = new_position
        
        new_birb.velocity.x = velocity * direction
        new_birb.velocity.y = y_offset
        await get_tree().create_timer(0.1).timeout
        
        # with a newly created birb, and its position and velocities set, add it to the scene
        add_child(new_birb)
        
        
    
