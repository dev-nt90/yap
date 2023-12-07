extends Area2D

signal ruby_collected

# Called when the node enters the scene tree for the first time.
func _ready():
    $ruby.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    pass


func _on_body_entered(_body):
    # TODO play "collected" animation
    emit_signal("ruby_collected")
    
    queue_free()
