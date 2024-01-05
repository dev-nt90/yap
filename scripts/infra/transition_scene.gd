extends CanvasLayer

signal faded_to_black
signal faded_to_normal

func fade_to_black():
    $TransitionSceneAnimationPlayer.play("fade_to_black")

func fade_to_normal():
    $TransitionSceneAnimationPlayer.play("fade_to_normal")

func _on_transition_scene_animation_player_animation_finished(anim_name):
    if anim_name == "fade_to_black":
        emit_signal("faded_to_black")
    if anim_name == "fade_to_normal":
        emit_signal("faded_to_normal")

func _on_scene_manager_scene_started():
    fade_to_normal()
