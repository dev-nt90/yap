extends Area2D

signal level_end_area_entered

func _on_body_entered(_body):
    emit_signal("level_end_area_entered")
