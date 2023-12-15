extends Control

func _ready():
    $AnimationPlayer.play("fade_out")

func _on_health_bar_value_changed(_value):
    $AnimationPlayer.play("fade_in")
    $HealthBarVisibleTimer.start()

func _on_health_bar_visible_timer_timeout():
    $AnimationPlayer.play("fade_out")
    $HealthBarVisibleTimer.stop()

func set_max_value(new_max_value):
    $HealthBar.max_value = new_max_value
    
func set_current_value(new_current_value):
    $HealthBar.value = new_current_value
