extends Area2D

func _ready():
    $emerald.play()

func _on_body_entered(_body):
    call_deferred("disable_collision")
    
    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(self, "position", Vector2(0, -100), 5).as_relative()
    tween.tween_property($emerald, "speed_scale", 3, 1)
    tween.set_parallel(false)
    
    # play emerald collected sound effect
    get_parent().get_parent().get_node("sfx").get_node("emerald").play()
    
    # update hud
    get_parent().get_parent().get_node("HUD").increment_emerald_count()
    
    tween.tween_callback(self.queue_free)

func disable_collision():
    $CollisionShape2D.disabled = true
