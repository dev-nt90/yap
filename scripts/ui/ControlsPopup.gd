extends Control

func _ready():
    process_mode = Node.PROCESS_MODE_WHEN_PAUSED
    hide()

func _on_close_button_pressed():
    get_parent().get_parent().show_pause_menu()
    hide()

func _on_close_button_gui_input(event):
    if event is InputEventJoypadButton:
        if event.button_index == JOY_BUTTON_A and event.pressed:
            _on_close_button_pressed()

func _on_advanced_button_pressed():
    get_parent().get_node("AdvancedControlsPopup").show()
    hide()

func _on_advanced_button_gui_input(event):
    if event is InputEventJoypadButton:
        if event.button_index == JOY_BUTTON_A and event.pressed:
            _on_advanced_button_pressed()
