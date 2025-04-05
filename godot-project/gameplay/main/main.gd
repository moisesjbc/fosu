extends Node2D


func _ready():
	$level.driller = $driller


func _on_target_area_driller_entered():
	get_tree().reload_current_scene()


func _on_level_bomb_drilled():
	$gui/game_over.start()
