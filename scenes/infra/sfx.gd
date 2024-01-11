extends Node

var ruby_played_count = 0

func _ready():
    $ruby.max_polyphony = 16

func _on_ruby_finished():
    # this is a silly implementation, but there's something there
    #var modifier = 1 if ruby_played_count % 2 == 0 else -1
    #$ruby.pitch_scale = 1.0 + (.05 * modifier * (ruby_played_count % 8))
    #print("ruby pitch_scale %02f" % $ruby.pitch_scale)
    #ruby_played_count += 1
    pass


func _on_wallslide_finished():
    $"wall-slide".play()
