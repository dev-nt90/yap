extends Area2D

signal emerald_collected

func _ready():
    $emerald.play()

func _on_body_entered(_body):
    emit_signal("emerald_collected")
    
    queue_free()
