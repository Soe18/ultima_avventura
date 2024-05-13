extends Control

@onready var scene_manager = get_tree().root.get_child(0)
@onready var score_label = %Score
var last_message = false

func _ready():
	var score = scene_manager.get_score()
	if score > 0:
		score_label.text = "Complimenti, il tuo punteggio
		ammonta a "+str(score)+"!"
	else:
		score_label.text = "Il gruppo ha finito la sua ultima avventura."
		last_message = true

func _process(_delta):
	if Input.is_action_just_pressed("confirm"):
		if !last_message:
			scene_manager.load_next_game()
		else:
			scene_manager.redirect_to_main_menu()
	pass
