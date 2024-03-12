extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
    $AnimationPlayer.play("idle")
    
func _on_body_entered(_body):
    call_deferred("disable_collision_deferred")
    
    # TODO: make this animation a tween
    $AnimationPlayer.play("collected")
    
    # play ruby collected sound effect
    get_parent().get_parent().get_node("sfx").get_node("ruby").play()
    
    # update hud
    get_parent().get_parent().get_node("HUD").increment_ruby_count()
    
func disable_collision_deferred():
    $CollisionShape2D.disabled = true
    
func _on_animation_player_animation_finished(anim_name):
    if anim_name == "collected":
        call_deferred("queue_free")
