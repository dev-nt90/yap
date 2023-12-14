extends Area2D

signal body_entered_cutscene

var entered = false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_body_entered(body):
    if not entered:
        entered = true
        emit_signal("body_entered_cutscene")
