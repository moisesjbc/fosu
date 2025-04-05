extends Node2D


const LEFT_ARROW_ID = 1
const RIGHT_ARROW_ID = 2

const FIRST_TILE_COLUMN = 1
const LAST_TILE_COLUMN = 6


func _input(event):
	if event is InputEventMouseButton and event.pressed == false:
		var tilemap_pos = $tilemap.world_to_map(get_global_mouse_position())
		var clicked_tile = $tilemap.get_cellv(tilemap_pos)

		if clicked_tile == LEFT_ARROW_ID:
			move_row_left(tilemap_pos.y)
		elif clicked_tile == RIGHT_ARROW_ID:
			move_row_right(tilemap_pos.y)

func move_row_left(row_index):
	var first_tile = $tilemap.get_cell(FIRST_TILE_COLUMN, row_index)

	for column_index in range(FIRST_TILE_COLUMN, LAST_TILE_COLUMN):
		$tilemap.set_cell(column_index, row_index, $tilemap.get_cell(column_index + 1, row_index))

	$tilemap.set_cell(LAST_TILE_COLUMN, row_index, first_tile)


func move_row_right(row_index):
	var last_tile = $tilemap.get_cell(LAST_TILE_COLUMN, row_index)

	var column_index = LAST_TILE_COLUMN
	while column_index > FIRST_TILE_COLUMN:
		$tilemap.set_cell(column_index, row_index, $tilemap.get_cell(column_index - 1, row_index))
		column_index -= 1

	$tilemap.set_cell(FIRST_TILE_COLUMN, row_index, last_tile)
