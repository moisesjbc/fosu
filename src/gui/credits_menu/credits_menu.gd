extends Control


func _on_main_menu_button_pressed():
	get_tree().change_scene("res://gui/main_menu/main_menu.tscn")


func _on_credits_meta_clicked(meta):
	var error_code = OS.shell_open(meta)
	if error_code != 0:
		print('ERROR opening ' + meta + ' - error code: ' + str(error_code))
