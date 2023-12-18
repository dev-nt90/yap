extends CanvasLayer


var seconds_elapsed = 0
var gemPattern = "X %02d"
var rubyCount = 0
var emeraldCount = 0
var par_time

func _ready():
    $TimeElapsedTimer.start()
    $ruby.play()
    $emerald.play()
    $RubyCount.text = String(gemPattern % rubyCount)
    $EmeraldCount.text = String(gemPattern % emeraldCount)
    par_time = get_parent().get_par_time()
    
    var total_ruby_count = get_parent().get_node("Rubies").get_child_count()
    var total_emerald_count = get_parent().get_node("Emeralds").get_child_count()
    $LevelCompleteScreenContainer.set_ruby_total(total_ruby_count)
    $LevelCompleteScreenContainer.set_emerald_total(total_emerald_count)

func _on_time_elapsed_timer_timeout():
    seconds_elapsed += 1
    var seconds = seconds_elapsed % 60
    var minutes = seconds_elapsed / 60
    var elapsed_string = "%02d:%02d" % [minutes, seconds]
    $TimeElapsedLabel.text = str(elapsed_string)

func increment_ruby_count():
    rubyCount += 1
    $RubyCount.text = String(gemPattern % rubyCount)

func increment_emerald_count():
    emeraldCount += 1
    $EmeraldCount.text = String(gemPattern % emeraldCount)

func get_current_ruby_count():
    return rubyCount
    
func get_current_emerald_count():
    return emeraldCount

func _on_player_player_death():
    reset_ui()
    $GameOverScreen.show()
    
func reset_ui():
    rubyCount = 0
    emeraldCount = 0
    $RubyCount.text = String(gemPattern % rubyCount)
    $EmeraldCount.text = String(gemPattern % emeraldCount)
    $TimeElapsedLabel.text = str(0)

func _on_player_level_exit_requirements_met():
    # TODO: do we need to pause the game for this?
    # TODO: stats object for times, collectibles, combat, etc? keeping track of this stuff directly in the HUD isn't great
    # collectibles
    $LevelCompleteScreenContainer.set_ruby_progress(self.rubyCount)
    $LevelCompleteScreenContainer.set_emerald_progress(self.emeraldCount)
    
    # combat
    var enemies_defeated = 0 # TODO: track this
    # TODO: this won't work as we queue_free deleted enemies, fix this such that it works in the same way as collectibles
    var enemies_total = get_parent().get_node("Enemies").get_child_count() 
    $LevelCompleteScreenContainer.set_enemy_progress(enemies_defeated, enemies_total)
    
    # time
    $TimeElapsedTimer.stop()
    $LevelCompleteScreenContainer.set_time_elapsed()
    $LevelCompleteScreenContainer.set_par_time(par_time)
    $LevelCompleteScreenContainer.set_time_diff()
    
    $LevelCompleteScreenContainer.show()
