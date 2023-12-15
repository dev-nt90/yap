extends CanvasLayer

var seconds_elapsed = 0
var gemPattern = "X %02d"
var rubyCount = 0
var emeraldCount = 0

func _ready():
    $TimeElapsedTimer.start()
    $ruby.play()
    $emerald.play()
    $RubyCount.text = String(gemPattern % rubyCount)
    $EmeraldCount.text = String(gemPattern % emeraldCount)

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
