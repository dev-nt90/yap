extends CanvasLayer

signal transitioned

func transition():
    $TransitionSceneAnimationPlayer.play("fade_to_black")

func _on_transition_scene_animation_player_animation_finished(anim_name):
    if anim_name == "fade_to_black":
        emit_signal("transitioned")
        $TransitionSceneAnimationPlayer.play("fade_to_normal")
