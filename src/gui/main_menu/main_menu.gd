extends Control


func _ready():
	$margin_container/vbox_container/exit_button.visible = (OS.get_name() != "HTML5")


func _on_play_button_pressed():
	get_tree().change_scene("res://gameplay/main/main.tscn")


func _on_how_to_play_button_pressed():
	get_tree().change_scene("res://gui/how_to_play_menu/how_to_play_menu.tscn")


func _on_credits_button_pressed():
	get_tree().change_scene("res://gui/credits_menu/credits_menu.tscn")


func _on_exit_button_pressed():
	get_tree().quit()
