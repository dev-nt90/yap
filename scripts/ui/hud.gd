extends CanvasLayer

@export var debug:bool = false

var seconds_elapsed = 0
var gemPattern = "X %02d"
var rubyCount = 0
var emeraldCount = 0
var enemy_defeated_count = 0
var par_time
@export var level_name : String

func _ready():
    $LevelNameLabel.text = level_name
    
    $TimeElapsedTimer.start()
    $ruby.play()
    $emerald.play()
    $RubyCount.text = String(gemPattern % rubyCount)
    $EmeraldCount.text = String(gemPattern % emeraldCount)
    par_time = get_parent().get_par_time()
    
    var total_ruby_count = get_parent().get_node("Rubies").get_child_count()
    var total_emerald_count = get_parent().get_node("Emeralds").get_child_count()
    var total_enemy_count = get_parent().get_node("Enemies").get_child_count()
    
    $LevelCompleteScreenContainer.set_ruby_total(total_ruby_count)
    $LevelCompleteScreenContainer.set_emerald_total(total_emerald_count)
    $LevelCompleteScreenContainer.set_enemy_total(total_enemy_count)
    
    $DebugStateLabel.visible = debug
    $DebugPosLabel.visible = debug

func set_debug_pos_label(position: Vector2):
    $DebugPosLabel.text = "pos.x %02d pos.y %02d" % [position.x, position.y]

func set_debug_state_label(state):
    $DebugStateLabel.text = "state: %s" % state
    
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
    enemy_defeated_count = 0
    #TODO: enemy defeated label
    $RubyCount.text = String(gemPattern % rubyCount)
    $EmeraldCount.text = String(gemPattern % emeraldCount)
    $TimeElapsedLabel.text = str(0)

func _on_player_level_exit_requirements_met():
    # TODO: stats object for times, collectibles, combat, etc? keeping track of this stuff directly in the HUD isn't great
    # collectibles
    $LevelCompleteScreenContainer.set_ruby_progress(self.rubyCount)
    $LevelCompleteScreenContainer.set_emerald_progress(self.emeraldCount)
    
    # combat
    $LevelCompleteScreenContainer.set_enemy_progress(self.enemy_defeated_count)
    
    # time
    $TimeElapsedTimer.stop()
    $LevelCompleteScreenContainer.set_time_elapsed()
    $LevelCompleteScreenContainer.set_par_time(par_time)
    $LevelCompleteScreenContainer.set_time_diff()
    
    $LevelCompleteScreenContainer.show()

func _on_shroomy_enemy_defeated():
    enemy_defeated_count += 1
