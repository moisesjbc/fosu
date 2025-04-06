extends Node


onready var on_mobile_platform = JavaScript.eval("/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)", true)


func _ready():
	if on_mobile_platform:
		$button_pressed.volume_db = -20


func play_button_pressed_sound():
	$button_pressed.play()
