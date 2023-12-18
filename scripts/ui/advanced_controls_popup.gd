extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
    process_mode = Node.PROCESS_MODE_WHEN_PAUSED
    hide()

func _on_close_button_pressed():
    get_parent().get_node("ControlsPopup").show()
    hide()

func _on_close_button_gui_input(event):
    if event is InputEventJoypadButton:
        if event.button_index == JOY_BUTTON_A and event.pressed:
            _on_close_button_pressed()
