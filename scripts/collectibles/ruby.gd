extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
    $ruby.play()

func _on_body_entered(_body):
    # TODO play "collected" animation
    
    # play ruby collected sound effect
    get_parent().get_parent().get_node("sfx").get_node("ruby").play()
    
    # update hud
    get_parent().get_parent().get_node("HUD").increment_ruby_count()

    queue_free()
