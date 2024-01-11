extends Control

var hint_pattern = "X %02d/%02d (%02d%%)"

func _ready():
    $ColorRect/emerald.play()
    $ColorRect/ruby.play()

func set_ruby_progress(current_ruby_count, ruby_total):
    if(current_ruby_count >= ruby_total):
        set_ruby_complete()
    else:
        var ruby_percent = float(current_ruby_count)/float(ruby_total) * 100
        $ColorRect/RubyRequirementLabel.text = String(hint_pattern % [current_ruby_count, ruby_total, ruby_percent])

func set_emerald_progress(current_emerald_count, emerald_total):
    if (current_emerald_count >= emerald_total):
        set_emerald_complete()
    else:
        var emerald_percent = float(current_emerald_count)/float(emerald_total) * 100
        $ColorRect/EmeraldRequirementLabel.text = String(hint_pattern % [current_emerald_count, emerald_total, emerald_percent])
    
func set_ruby_complete():
    $ColorRect/RubyRequirementLabel.bbcode_text = "[rainbow][wave]complete![/wave][/rainbow]"

func set_emerald_complete():
    $ColorRect/EmeraldRequirementLabel.bbcode_text = "[rainbow][wave]complete![/wave][/rainbow]"
