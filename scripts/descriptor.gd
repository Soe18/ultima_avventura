extends Sprite2D

@onready var title = %Title
@onready var description = %Description
@onready var describer = get_parent().describer

const top_text_y = -39
const bottom_text_y = -5

func load_descr(ability):
	if not ability: # We're on the padding (-)
		self.title.text = ""
		self.description.text = ""
	else:
		self.title.text = ability
		var descr = describer.abilities_list.get(ability)
		if descr == null:
			descr = "Nessuna descrizione trovata"
		self.description.text = descr
	
func default_dialogue(player_name):
	self.title.text = "Cosa fara' "+player_name+"?"
	self.description.text = ""

func reset_text():
	self.title.text = ""
	self.description.text = ""
	self.description.position.y = bottom_text_y

func display_effects(effect_text):
	self.title.text = ""
	self.description.text = effect_text
	self.description.position.y = top_text_y
