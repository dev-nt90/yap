extends Area2D

signal door_opened

@onready var player = get_parent().get_parent().get_node("Player")

func open_door():
    $AnimationPlayer.play("open")
    
    # TODO: sfx
    emit_signal("door_opened")
    # queue free?
    
func _on_body_entered(_body):
    var key_count = player.get_key_count()
    if key_count > 0:
        open_door()


func _on_animation_player_animation_finished(anim_name):
    if anim_name == "open":
        $StaticBody2D.queue_free()
        $CollisionShape2D.disabled = true
