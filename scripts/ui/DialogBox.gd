extends Control

signal dialogue_ended

@export var dialogue = []
var dialogue_index = 0
var finished = false
var char_read_rate = .01

func _ready():
    load_dialogue()
    
func _process(_delta):
    
    if Input.is_action_just_pressed("ui_accept"):
        if not finished:
            finished=true
            $RichTextLabel.visible_ratio = 1.0
        else:
            load_dialogue()
    
    # TODO: need to normalize the rate at which text appears in these dialog boxes, as there's currently a large discrepancy between how fast small and large messages are rendered        
    if $RichTextLabel.visible_ratio < 1.0:
        $RichTextLabel.visible_ratio += char_read_rate
    else:
        finished = true
    $TextCompleteIcon.visible = finished
    
func load_dialogue():
    if dialogue_index < dialogue.size():
        finished = false
        
        var dialogue_text = dialogue[dialogue_index]
        $RichTextLabel.bbcode_text = dialogue_text
        $RichTextLabel.visible_ratio = 0.0
        dialogue_index += 1
    else:
        # todo: is this a race condition?
        emit_dialogue_ended()
        queue_free()

func emit_dialogue_ended():
    emit_signal("dialogue_ended")
