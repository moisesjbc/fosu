extends TileMap


const LEFT_ARROW_ID = 1
const RIGHT_ARROW_ID = 2
const EARTH_ID = 0
const BOMB_ID = 4
const SHIELD_ID = 5

const FIRST_TILE_COLUMN = 1
const LAST_TILE_COLUMN = 6

const FIRST_VISIBLE_ROW = 1
const LAST_VISIBLE_ROW = 14

const TILE_WIDTH = 64
const TILES_PER_ROW = 6

var driller

var drill_timeout
var special_cell_probability
var powerup_probability

var highlighted_row = -1
var on_mobile_platform = false

signal bomb_drilled
signal row_drilled

func _ready():
	on_mobile_platform = JavaScript.eval("/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)", true)


func start(driller, drill_timeout, special_cell_probability, powerup_probability):
	self.driller = driller
	self.special_cell_probability = special_cell_probability
	self.drill_timeout = drill_timeout
	self.powerup_probability = powerup_probability

	$drill_timer.start(drill_timeout)


func highlight_row(row_index):
	highlighted_row = row_index

	if row_index >= 0:
		$row_highlight.visible = true
		$row_highlight.position.y = (TILE_WIDTH / 2) + row_index * TILE_WIDTH
	else:
		$row_highlight.visible = false


func _physics_process(delta):
	if not on_mobile_platform:
		var tilemap_pos = world_to_map(get_global_mouse_position())
		if get_cell(0, tilemap_pos.y) == LEFT_ARROW_ID:
			highlight_row(tilemap_pos.y)
			
			if Input.is_action_just_pressed("ui_left"):
				move_row_left(highlighted_row)
			elif Input.is_action_just_pressed("ui_right"):
				move_row_right(highlighted_row)
			
		else:
			highlight_row(-1)


func _input(event):
	if event is InputEventMouseButton and event.pressed == false:
		var tilemap_pos = world_to_map(get_global_mouse_position())
		var clicked_tile = get_cellv(tilemap_pos)

		if clicked_tile == LEFT_ARROW_ID:
			move_row_left(tilemap_pos.y)
		elif clicked_tile == RIGHT_ARROW_ID:
			move_row_right(tilemap_pos.y)


func move_row_left(row_index):
	get_node("/root/global_sound_system").play_button_pressed_sound()
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
	get_node("/root/global_sound_system").play_button_pressed_sound()
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


func drill():
	$drill.play()
	create_new_row()

	for row_index in range(FIRST_VISIBLE_ROW, LAST_VISIBLE_ROW + 1):
		for column_index in range(FIRST_TILE_COLUMN, LAST_TILE_COLUMN + 1):
			set_cell(column_index, row_index, get_cell(column_index, row_index + 1))

	var driller_current_pos = world_to_map(driller.global_position)
	var driller_tile = get_cellv(driller_current_pos)
	emit_signal("row_drilled")
	if driller_tile == BOMB_ID:
		if driller.shield_activated():
			driller.deactivate_shield()
		else:
			emit_signal("bomb_drilled")
	elif driller_tile == SHIELD_ID:
		$powerup.play()
		driller.activate_shield()
	set_cellv(driller_current_pos, -1)
	
	$drill_timer.start(drill_timeout)


func create_new_row():
	var powerup_already_added = false
	randomize()

	# Randomly add dangers
	var safe_column = FIRST_TILE_COLUMN + (randi() % (LAST_TILE_COLUMN - FIRST_TILE_COLUMN + 1))
	for column_index in range(FIRST_TILE_COLUMN, LAST_TILE_COLUMN + 1):
		var cell_value = EARTH_ID
		if column_index != safe_column and randf() <= special_cell_probability:
			if not powerup_already_added and randf() <= powerup_probability:
				powerup_already_added = true
				cell_value = SHIELD_ID
			else:
				cell_value = BOMB_ID
		set_cell(column_index, LAST_VISIBLE_ROW + 1, cell_value)


func _on_drill_timer_timeout():
	drill()
