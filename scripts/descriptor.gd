extends Sprite2D

@onready var title = %Title
@onready var description = %Description
@onready var describer = get_parent().describer

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

func display_effects(effect_text):
	self.title.text = ""
	self.description.text = effect_text
