extends Area2D

signal key_collected

func _on_body_entered(_body):
    emit_signal("key_collected")
    # TOOD: play animation, sound
    queue_free()
