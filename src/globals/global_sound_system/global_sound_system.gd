extends Node


onready var on_mobile_platform = JavaScript.eval("/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)", true)


func _ready():
	if on_mobile_platform:
		var sfx_index = AudioServer.get_bus_index("sfx")
		AudioServer.set_bus_volume_db(sfx_index, -20)


func play_button_pressed_sound():
	$button_pressed.play()
