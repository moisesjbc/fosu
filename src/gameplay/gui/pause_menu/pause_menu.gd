extends Control


func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_ESCAPE:
		start()

func start():
	get_tree().paused = true
	$center_container.visible = true


func _on_resume_pressed():
	get_tree().paused = false
	$center_container.visible = false


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://gui/main_menu/main_menu.tscn")
