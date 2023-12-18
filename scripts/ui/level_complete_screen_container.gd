extends Control

const GEMS_COLLECTED_PATTERN = "collected: %02d/%02d (%.04f%%)"
const TIME_ELAPSED_PATTERN = "Time elapsed for this run: %02d:%02d.%02d"
const PAR_TIME_PATTERN = "Par time for this level: %02d:%02d.%02d"
const ENEMIES_DEFEATED_PATTERN = "Enemies defeated: %02d/%02d (%02d%%)"

var time_elapsed
var par_time
var start_time_dict
var ruby_total : int
var emerald_total : int

func _ready():
    hide()    
    start_time_dict = get_current_time_dict_with_ms()

# HACK: in Godot 4 they made it slightly more difficult to get milliseconds with the removal of the OS functions
# this is an attempt to stopgap that problem
# https://forum.godotengine.org/t/why-was-getting-milliseconds-system-time-removed-in-godot-4-0/6381/3
func get_current_time_dict_with_ms():
    var unix_time: float = Time.get_unix_time_from_system()
    var unix_time_int: int = unix_time
    var dt: Dictionary = Time.get_datetime_dict_from_unix_time(unix_time)
    var ms: int = (unix_time - unix_time_int) * 1000.0
    dt["ms"] = ms
    
    return dt
    
# RestartButton
func _on_restart_button_pressed():
    SceneManager.reload_scene()

func _on_restart_button_gui_input(event):
    if event is InputEventJoypadButton:
        if event.button_index == JOY_BUTTON_A and event.pressed:
            _on_restart_button_pressed()

# ContinueButton
func _on_continue_button_pressed():
    SceneManager.load_next_level()

func _on_continue_button_gui_input(event):
    if event is InputEventJoypadButton:
        if event.button_index == JOY_BUTTON_A and event.pressed:
            _on_continue_button_pressed()

func set_ruby_total(ruby_total_in):
    self.ruby_total = ruby_total_in

func set_emerald_total(emerald_total_in):
    self.emerald_total = emerald_total_in

# collectible stats
func set_ruby_progress(current_ruby_count):
    var ruby_percent = float(current_ruby_count)/float(self.ruby_total) * 100
    var rubies_collected_str = ""
    
    if(current_ruby_count >= self.ruby_total):
        rubies_collected_str = String("[rainbow][wave]" + GEMS_COLLECTED_PATTERN % [current_ruby_count, self.ruby_total, ruby_percent] + "[/rainbow][/wave]")
    else:
        rubies_collected_str = String(GEMS_COLLECTED_PATTERN % [current_ruby_count, self.ruby_total, ruby_percent])
        
    $RubiesCollectedLabel.bbcode_text = rubies_collected_str

func set_emerald_progress(current_emerald_count):
    var emerald_percent = float(current_emerald_count)/float(self.emerald_total) * 100
    var emeralds_collected_str = ""
    
    if (current_emerald_count >= self.emerald_total):
        emeralds_collected_str = String("[rainbow][wave]" + GEMS_COLLECTED_PATTERN  % [current_emerald_count, self.emerald_total, emerald_percent] + "[/rainbow][/wave]")
    else:
        emeralds_collected_str = String(GEMS_COLLECTED_PATTERN % [current_emerald_count, self.emerald_total, emerald_percent])
        
    $EmeraldsCollectedLabel.bbcode_text = emeralds_collected_str

# combat stats
func set_enemy_progress(current_enemy_count, enemies_total):
    var enemy_percent = float(current_enemy_count)/float(enemies_total) * 100
    
    var enemies_defeated_str = ""
    if (current_enemy_count >= enemies_total):
        enemies_defeated_str = String("[rainbow][wave]" + ENEMIES_DEFEATED_PATTERN + "[/rainbow][/wave]" % [current_enemy_count, enemies_total, enemy_percent])
    else:
        enemies_defeated_str = String(ENEMIES_DEFEATED_PATTERN % [current_enemy_count, enemies_total, enemy_percent])
        
    $EnemiesDefeatedLabel.bbcode_text = enemies_defeated_str
    
# time stats
# elapsed-specific functions
func set_time_elapsed():
    $TimeElapsedLabel.bbcode_text = get_time_elapsed_str()

func get_milliseconds_elapsed():
    var current_time_dict = get_current_time_dict_with_ms()
    var hours = current_time_dict["hour"] - start_time_dict["hour"]
    var minutes = current_time_dict["minute"] - start_time_dict["minute"]
    var seconds = current_time_dict["second"] - start_time_dict["second"]
    var ms = current_time_dict["ms"] - start_time_dict["ms"]
    
    return (hours * 3600000) + \
        (minutes * 60000) + \
        (seconds * 1000) + \
        ms
    
func get_time_elapsed_str():
    var milliseconds_elapsed = get_milliseconds_elapsed()
    
    var parts = get_time_parts_from_ms(milliseconds_elapsed)
    
    var final_str = TIME_ELAPSED_PATTERN % [parts[0], parts[1], parts[2]]
    return final_str
    
# par-specific functions
func set_par_time(par_time_in):
    par_time = par_time_in
    var ms = get_ms_from_str(par_time)
    var parts = get_time_parts_from_ms(ms)
    var final_str = PAR_TIME_PATTERN % [parts[0], parts[1], parts[2]]
    $ParTimeLabel.bbcode_text = final_str

# diff  
func set_time_diff():
    if par_time == null || par_time == "":
        print("time elapsed or par time not set!")
        return 
    
    var par_ms = get_ms_from_str(par_time)
    var elapsed_ms = get_milliseconds_elapsed()
    var diff_ms = elapsed_ms - par_ms
    var diff_sign = ""
    var diff_type = ""
    
    # if elapsed time was faster than par time, indicate negative time
    if diff_ms > 0:
        diff_sign = "+"
    elif diff_ms < 0:
        diff_sign = "-"
        
    var diff_str = diff_sign + get_diff_time_str_from_ms(diff_ms)
    
    # if elapsed time was faster than par time, give positive feedback
    if diff_ms < 0:
        # HACK this
        diff_str = diff_str + " [rainbow][tornado](faster!)[/tornado][/rainbow]"
    elif diff_ms > 0:
        diff_type = " (slower)"
    else:
        diff_type = " (tie)"
        
    var final_diff_str = "Difference between your time and par time: " + diff_str + diff_type
    $TimeDiffLabel.bbcode_text = final_diff_str

# generic helper funcs
func get_diff_time_str_from_ms(ms):
    var parts = get_time_parts_from_ms(ms)
    return get_time_str_from_parts(parts)

func get_time_str_from_parts(parts: Array[int]):
    return "%02d:%02d.%03d" % parts.map(func(number): return abs(number))
    
func get_time_parts_from_ms(ms) -> Array[int]:
    return [
        int(ms/(1000*60)) % 60, # minutes
        int(ms/1000) % 60, # seconds
        ms % 1000 # milliseconds
    ]

func get_ms_from_str(time_str: String):
    var parts = time_str.split(":")
    if parts.size() != 2:
        print("Invalid time string format") # TODO: make this check at onready for par time
        return []
        
    var minutes = int(parts[0])
    var seconds_and_ms = parts[1].split(".")
    
    if seconds_and_ms.size() != 2:
        print("Invalid seconds_and_ms string format") # TODO: make this check at onready
        return []
        
    return (minutes * 60000) + \
        (int(seconds_and_ms[0]) * 1000) + \
        (int(seconds_and_ms[1]))
