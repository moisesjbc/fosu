extends KinematicBody2D


signal block_drilled
var shield_activated = false


func _ready():
	deactivate_shield()


func _on_timer_timeout():
	move_and_collide(Vector2(0, 128))
	emit_signal("block_drilled", self)


func activate_shield():
	$shield.visible = true


func deactivate_shield():
	$shield.visible = false


func shield_activated():
	return $shield.visible
