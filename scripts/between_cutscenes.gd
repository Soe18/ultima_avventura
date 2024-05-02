extends Control

@onready var scene_manager = get_tree().root.get_child(0)
@onready var score_label = %Score
var last_message = false

func _ready():
	var score = scene_manager.get_score()
	if score > 0:
		score_label.text = str(score)
	else:
		score_label.text = "Too bad! Game over"
		last_message = true

func _process(_delta):
	if Input.is_action_just_pressed("confirm"):
		if !last_message:
			scene_manager.load_next_game()
		else:
			#TODO: main menu
			get_tree().quit()
	pass
