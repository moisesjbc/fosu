extends Node2D




func _on_target_area_driller_entered():
	get_tree().reload_current_scene()
