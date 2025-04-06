extends Node2D


func _ready():
	get_tree().paused = true


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://gui/main_menu/main_menu.tscn")
