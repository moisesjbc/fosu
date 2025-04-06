extends Area2D


signal driller_entered


func _on_target_area_body_entered(body):
	if body.name == "driller":
		emit_signal("driller_entered")
