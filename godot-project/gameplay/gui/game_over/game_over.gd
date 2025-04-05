extends Control


func start():
	get_tree().paused = true
	visible = true


func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
