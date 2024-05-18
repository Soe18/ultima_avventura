extends Node2D

# '-' means null value, AND cannot be selected

var curr_selection = Vector2(0,0)
var pos_matrix
var actual_matrix
var all_elements
var skipped_rows : int = 0
@onready var pointer = %Pointer
@onready var up_indicator = %UpIndicator
@onready var down_indicator = %DownIndicator

enum SHIFT_ROWS {Up, Down}

# Called when the node enters the scene tree for the first time.
func _ready():
	pos_matrix = [[$Markers/TopLeft, $Markers/TopRight],
				[$Markers/BottomLeft, $Markers/BottomRight],]
	actual_matrix = [["", ""],
				["", ""],]
	update_posix()

# DIM of x length of menu
func get_max_x():
	return pos_matrix[0].size()-1

func get_max_y():
	return pos_matrix.size()-1

func move_left():
	curr_selection.x -= 1
	check_out_of_bounds()
	update_posix()

func move_right():
	curr_selection.x += 1
	check_out_of_bounds()
	update_posix()

func move_up():
	curr_selection.y -= 1
	check_out_of_bounds()
	update_posix()

func move_down():
	curr_selection.y += 1
	check_out_of_bounds()
	update_posix()

# Aggiorna la posizione del puntatore
func update_posix():
	pointer.position = pos_matrix[curr_selection.y][curr_selection.x].position

# Controlla che puntatore non vada fuori dal menu
func check_out_of_bounds():
	if curr_selection.x < 0:
		curr_selection.x = 0
	if curr_selection.y < 0:
		curr_selection.y = 0
		invisible_rows_manager(SHIFT_ROWS.Up)
	if curr_selection.x > get_max_x():
		curr_selection.x = get_max_x()
	if curr_selection.y > get_max_y():
		curr_selection.y = get_max_y()
		invisible_rows_manager(SHIFT_ROWS.Down)

# Show the upper or below row
func invisible_rows_manager(shiftrows):
	if shiftrows == SHIFT_ROWS.Up:
		skipped_rows -= 1
		if skipped_rows < 0:
			skipped_rows = 0
	if shiftrows == SHIFT_ROWS.Down:
		skipped_rows += 1
		if skipped_rows >= (all_elements.size()/2)-2:
			skipped_rows = (all_elements.size()/2)-2
	show_suggestors()

func show_suggestors():
	# Check up_indicator
	if skipped_rows > 0:
		up_indicator.visible = true
	else:
		up_indicator.visible = false
	# Check down_indicator
	if all_elements.size() > 4 and skipped_rows != (all_elements.size()/2)-2:
		# if there are more than 4 elems and we're not on last row
		down_indicator.visible = true
	else:
		down_indicator.visible = false

func update_fields(array):
	while array.size() < 4:
		array.append("-")
	
	if array.size() % 2 == 1:
		array.append("-")
	all_elements = array
	update_view()
	show_suggestors()

func update_view():
	# Update actual_matrix	
	actual_matrix[0][0] = all_elements[(skipped_rows*2)+0]
	actual_matrix[0][1] = all_elements[(skipped_rows*2)+1]
	actual_matrix[1][0] = all_elements[(skipped_rows*2)+2]
	actual_matrix[1][1] = all_elements[(skipped_rows*2)+3]
	
	# Update labels
	$TopLeftLabel.text = actual_matrix[0][0]
	$TopRightLabel.text = actual_matrix[0][1]
	$BottomLeftLabel.text = actual_matrix[1][0]
	$BottomRightLabel.text = actual_matrix[1][1]

# Returns false if value is "-"
func get_field():
	var val = actual_matrix[curr_selection.y][curr_selection.x]
	if val == "-":
		val = false
	return val
	
func reset_posix():
	curr_selection.x = 0
	curr_selection.y = 0
	skipped_rows = 0
	update_posix()
