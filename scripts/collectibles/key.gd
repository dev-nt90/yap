extends Area2D

signal key_collected

@onready var hud = get_parent().get_parent().get_node("HUD")
var canvas_sprite : Sprite2D

func _on_body_entered(_body):
    # disable collision so "double collecting" is disallowed
    call_deferred("disable_collision") 
    
    # TODO: sfx
    
     # finally, animate the collection of this object
    animate_collected()
    
func animate_collected():
    # strategy: 
    # 1) create a copy of our target sprite
    # 2) make the original sprite invisible
    # 3) add the duplicate to the canvas layer (called "hud" in this case)
    # 4) set the duplicate's position _in the canvas layer_ to the relative position of the 
    #    original _in the viewport_ (this is the secret sauce)
    # 5) create a tween to move from the duplicate's position in the canvas layer to the hud's sprite
    # The effect looks like we're "collecting" items in our inventory by pushing it from the game world to the hud
    canvas_sprite = $Sprite2D.duplicate()
    $Sprite2D.visible = false
    
    hud.add_child(canvas_sprite)
    canvas_sprite.position = self.get_global_transform_with_canvas().origin
    
    var tween = create_tween()
    
    tween.tween_property(canvas_sprite, "position", hud.get_node("Key").position, 1) \
        .set_trans(Tween.TRANS_QUART) \
        .set_ease(Tween.EASE_IN)
    tween.set_parallel(false)
    tween.tween_callback(_on_tween_completed)
    
func _on_tween_completed():
    # emit after animation is complete so it looks like the key is "moving" into our inventory
    emit_signal("key_collected")
    
    # free the canvas item and ourselves after animation is complete
    canvas_sprite.queue_free()
    self.queue_free()
    
func disable_collision():
    $CollisionShape2D.disabled = true
