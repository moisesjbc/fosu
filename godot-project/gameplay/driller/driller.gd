extends KinematicBody2D


signal block_drilled


func _on_timer_timeout():
	move_and_collide(Vector2(0, 128))
	emit_signal("block_drilled", self)

