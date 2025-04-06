extends Button


func _on_button_pressed():
	get_node("/root/global_sound_system").play_button_pressed_sound()
