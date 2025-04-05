extends Node2D

export var INITIAL_DRILL_TIMEOUT = 2
export var DELTA_DRILL_TIMEOUT = 0.1

export var INITIAL_SPECIAL_CELL_PROBABILITY = 0.3
export var SPECIAL_CELL_PROBABILITY_DELTA = 0.05


func _ready():
	$level.start($driller, INITIAL_DRILL_TIMEOUT, INITIAL_SPECIAL_CELL_PROBABILITY)


func _on_level_bomb_drilled():
	$gui/game_over.start()


func _on_difficulty_timer_timeout():
	$level.drill_timeout -= DELTA_DRILL_TIMEOUT
	$level.special_cell_probability += SPECIAL_CELL_PROBABILITY_DELTA


func _on_level_row_drilled():
	$gui/score.increase_score(1)
