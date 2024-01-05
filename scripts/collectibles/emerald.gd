extends Area2D

func _ready():
    $emerald.play()

func _on_body_entered(_body):
    # TODO play "collected" animation
    # play emerald collected sound effect
    get_parent().get_parent().get_node("sfx").get_node("emerald").play()
    
    # update hud
    get_parent().get_parent().get_node("HUD").increment_ruby_count()
    
    queue_free()
