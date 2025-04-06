extends Control


func start():
	get_tree().paused = true
	visible = true


func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://gui/main_menu/main_menu.tscn")
