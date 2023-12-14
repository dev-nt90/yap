extends Area2D

signal ruby_collected

# Called when the node enters the scene tree for the first time.
func _ready():
    $ruby.play()

func _on_body_entered(_body):
    # TODO play "collected" animation
    emit_signal("ruby_collected")
    
    queue_free()
