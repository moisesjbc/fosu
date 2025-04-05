extends TileMap


const LEFT_ARROW_ID = 1
const RIGHT_ARROW_ID = 2
const EARTH_ID = 0
const BOMB_ID = 4

const FIRST_TILE_COLUMN = 1
const LAST_TILE_COLUMN = 6

const LAST_VISIBLE_ROW = 14

const TILE_WIDTH = 128
const TILES_PER_ROW = 6

var driller


signal bomb_drilled


func _input(event):
	if event is InputEventMouseButton and event.pressed == false:
		var tilemap_pos = world_to_map(get_global_mouse_position())
		var clicked_tile = get_cellv(tilemap_pos)
		print("tilemap_pos ", tilemap_pos)
		print("clicked_tile ", clicked_tile)

		if clicked_tile == LEFT_ARROW_ID:
			move_row_left(tilemap_pos.y)
		elif clicked_tile == RIGHT_ARROW_ID:
			move_row_right(tilemap_pos.y)

func move_row_left(row_index):
	var first_tile = get_cell(FIRST_TILE_COLUMN, row_index)

	for column_index in range(FIRST_TILE_COLUMN, LAST_TILE_COLUMN):
		set_cell(column_index, row_index, get_cell(column_index + 1, row_index))

	set_cell(LAST_TILE_COLUMN, row_index, first_tile)
	
	# Move driller (if in the row)
	var driller_pos = world_to_map(driller.global_position)
	if driller_pos.y == row_index:
		if driller_pos.x > FIRST_TILE_COLUMN:
			driller.translate(Vector2(-TILE_WIDTH, 0))
		else:
			driller.translate(Vector2(TILE_WIDTH * (TILES_PER_ROW - 1), 0))


func move_row_right(row_index):
	var last_tile = get_cell(LAST_TILE_COLUMN, row_index)

	var column_index = LAST_TILE_COLUMN
	while column_index > FIRST_TILE_COLUMN:
		set_cell(column_index, row_index, get_cell(column_index - 1, row_index))
		column_index -= 1

	set_cell(FIRST_TILE_COLUMN, row_index, last_tile)
	
	# Move driller (if in the row)
	var driller_pos = world_to_map(driller.global_position)
	if driller_pos.y == row_index:
		if driller_pos.x < LAST_TILE_COLUMN:
			driller.translate(Vector2(+TILE_WIDTH, 0))
		else:
			driller.translate(Vector2(-TILE_WIDTH * (TILES_PER_ROW - 1), 0))

func _on_timer_timeout():
	dig()


func dig():
	create_new_row()

	for row_index in range(0, LAST_VISIBLE_ROW + 1):
		for column_index in range(FIRST_TILE_COLUMN - 2, LAST_TILE_COLUMN + 2):
			set_cell(column_index, row_index, get_cell(column_index, row_index + 1))

	var driller_current_pos = world_to_map(driller.global_position)
	var driller_tile = get_cellv(driller_current_pos)
	if driller_tile == BOMB_ID:
		emit_signal("bomb_drilled")
	set_cellv(driller_current_pos, -1)


func create_new_row():
	randomize()

	for column_index in range(FIRST_TILE_COLUMN, LAST_TILE_COLUMN + 1):
		set_cell(column_index, LAST_VISIBLE_ROW + 1, EARTH_ID)

	# Randomly add arrows
	if randf() < 0.4:
		set_cell(FIRST_TILE_COLUMN - 1, LAST_VISIBLE_ROW + 1, LEFT_ARROW_ID)
		set_cell(LAST_TILE_COLUMN + 1, LAST_VISIBLE_ROW + 1, RIGHT_ARROW_ID)
	else:
		set_cell(FIRST_TILE_COLUMN - 1, LAST_VISIBLE_ROW + 1, -1)
		set_cell(LAST_TILE_COLUMN + 1, LAST_VISIBLE_ROW + 1, -1)
