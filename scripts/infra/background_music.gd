extends Node

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS

# HACK: makes specific songs loop, would be nice to make generic
func _on_forgotten_finished():
    $Forgotten.play()
