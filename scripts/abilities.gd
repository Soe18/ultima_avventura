extends Node2D

# Name every animations EXACTLY like 
var default_animation_pos = "res://assets/animations/"
var animation
@onready var g = get_parent() # Stands for gameplay
@onready var descriptor = %Descriptor
@onready var anim_cooldown = %AnimationCooldown
var player
var target

# For now, it just start a timer to prevent spam...
func always_at_end_attack():
	anim_cooldown.start()

func basic_damage_formula(sender_atk, strength, receiver_def):
	var padding = randi_range(1, strength*10)
	var damage = int((sender_atk*strength)-receiver_def)+padding
	if damage < padding:
		damage = padding 
	return damage

# Main func which applies the method given the ability
func do_ability(user):
	player = user
	if player.is_boss:
		# select a random ability
		player.choose_random_ability()
		target = g.players.pick_random()
	
	# Save the func needed to connect
	var func_ability
	var doable = true
	match user.curr_sel:
		"Recupero":
			func_ability = do_recover
			doable = true
		"Fuoca":
			func_ability = do_fuoca
			doable = do_fuoca(false)
		"Tuonaga":
			func_ability = do_tuonaga
			doable = do_tuonaga(false)
		"Fulmato":
			func_ability = do_fulmato
			doable = do_fulmato(false)
		"Elira":
			pass
			#func_ability = do_fuoca
			#doable = do_fuoca(false)
		"Distrai":
			func_ability = do_distrai
			doable = do_distrai(false)
		"Egida":
			pass
			#func_ability = do_fuoca
			#doable = do_fuoca(false)
		"Taglio":
			func_ability = do_taglio
		"Hachi":
			func_ability = do_hachi
			doable = do_hachi(false)
		"Panino":
			func_ability = do_panino
			doable = do_panino(false)
		"Acqua":
			func_ability = do_acqua
			doable = do_acqua(false)
		"Talismano":
			func_ability = do_talismano
			doable = do_talismano(false)
		"Liv":
			func_ability = do_liv
			doable = do_liv(false)
		"Hideki":
			func_ability = do_hideki
			doable = do_hideki(false)
		"Yoku":
			func_ability = do_yoku
			doable = do_yoku(false)
		"Tonfo":
			func_ability = do_tonfo
		"Morso":
			func_ability = do_morso
		"Ragnatela":
			func_ability = do_ragnatela

	# We need to check if player can do it or not
	# Every do_ab func, if they have a false parameter,
	# means we only wants to see if the player will be able to do it
	if not doable:
		descriptor.display_effects(player.player_info.name+" non ha potuto fare niente!")
		always_at_end_attack()
		return null

	play_anim("Fuoca") # in the future... user.curr_sel
	animation.animation_finished.connect(func_ability)

# Example methods:
# Animation
func play_anim(anim_name):
	animation = AnimatedSprite2D.new()
	animation.sprite_frames = load(default_animation_pos+anim_name+"/"+anim_name+".tres")
	add_child(animation)
	animation.z_index = 10
	animation.sprite_frames.set_animation_loop("anim", false)
	g.animation_playing = true
	animation.play()
	animation.centered = false
	animation.scale = Vector2(2,2)

func do_recover():
	remove_child(animation)
	g.animation_playing = false
	var mana_recovered = player.player_info.base_mana/4*3
	var hp_recovered = player.player_info.base_hp/4
	
	# Display at the top the result of your action
	descriptor.display_effects(player.player_info.name+" si è riposato, recuperando mana e vita.")
	
	# Add, if you want, some special effects here
	player.use_mana(-mana_recovered)
	player.receive_damage(-hp_recovered)
	
	# You don't need to know what is done here, just put it!
	always_at_end_attack()

# Example player ability
# When parameter is true, we only wants to check if player can do ability
# We return true or false only in this scenario
func do_fuoca(i_want_to_do_it : bool = true):
	# Choose the integer multiplyer of ability
	const damage_multiplyer = 1.5
	# Define how much mana you do need for the ability
	const mana_usage = 100
	
	# Defined for its ability, in most use case, ignore this
	const mana_recover = 50
	
	if not i_want_to_do_it:
		if mana_usage > player.curr_mana:
			return false
		else:
			return true
	# Stop the animation since it's finished
	remove_child(animation)
	# Tell the gameplay that the animation is finished
	g.animation_playing = false
	
	# Let's get to the fun part!
	# Check the damage done using the basic formula
	var damage_value = basic_damage_formula(player.curr_atk, damage_multiplyer, g.boss.curr_def)
	# Hit him!
	g.boss.receive_damage(damage_value)
	# If your ability uses mana, consume it
	player.use_mana(mana_usage)
	# Display at the top the result of your action
	descriptor.display_effects(player.player_info.name+" ha fatto "+str(damage_value)+" danni a "+g.boss.boss_info.name+". L`energia del drago, fa recuperare mana agli alleati.")
	
	# Add, if you want, some special effects here
	for a_player in g.players:
		if a_player != player and a_player.curr_hp > 0:
			a_player.use_mana(-mana_recover)
	
	# You don't need to know what is done here, just put it!
	always_at_end_attack()

# Example boss ability
func do_taglio():
	# Stop the animation since it's finished
	remove_child(animation)
	# Tell the gameplay that the animation is finished
	g.animation_playing = false
	
	# Choose the integer multiplyer of ability
	const damage_multiplyer = 1.3
	# Check the damage done using the basic formula
	var damage_value = basic_damage_formula(player.curr_atk, damage_multiplyer, target.curr_def)
	# Hit him!
	target.receive_damage(damage_value)
	# Display at the top the result of your action
	descriptor.display_effects(player.boss_info.name+" ha fatto "+str(damage_value)+" danni a "+target.player_info.name+"!")
	# You don't need to know what is done here, just put it!
	always_at_end_attack()

func do_tuonaga(i_want_to_do_it : bool = true):
	const damage_multiplyer = 1.6
	const mana_usage = 123
	const attack_addition = 10
	
	if not i_want_to_do_it:
		if mana_usage > player.curr_mana:
			return false
		else:
			return true
	remove_child(animation)
	g.animation_playing = false
	
	var damage_value = basic_damage_formula(player.curr_atk, damage_multiplyer, g.boss.curr_def)

	g.boss.receive_damage(damage_value)
	player.use_mana(mana_usage)

	descriptor.display_effects(player.player_info.name+" ha fatto "+str(damage_value)+" danni a "+g.boss.boss_info.name+". L`attacco di "+player.player_info.name+" aumenta!")
	
	# Add, if you want, some special effects here
	player.change_atk(attack_addition)
	
	always_at_end_attack()

func do_fulmato(i_want_to_do_it : bool = true):
	var damage_multiplyer = 1+(player.curr_mana/player.player_info.base_mana)
	
	if not i_want_to_do_it:
		if player.curr_mana <= 0:
			return false
		else:
			return true
	remove_child(animation)
	g.animation_playing = false
	
	var damage_value = basic_damage_formula(player.curr_atk, damage_multiplyer, g.boss.curr_def)

	g.boss.receive_damage(damage_value)
	player.use_mana(player.player_info.base_mana)

	descriptor.display_effects(player.player_info.name+" ha concentrato tutte le sue forze in un unico pungo da "+str(damage_value)+" danni a "+g.boss.boss_info.name+".")	
	always_at_end_attack()

func do_distrai(i_want_to_do_it : bool = true):
	const damage_multiplyer = 1.2
	const mana_usage = 66
	const debuff_def = 10
	
	if not i_want_to_do_it:
		if mana_usage > player.curr_mana:
			return false
		else:
			return true
	remove_child(animation)
	g.animation_playing = false
	
	var damage_value = basic_damage_formula(player.curr_atk, damage_multiplyer, g.boss.curr_def)

	g.boss.receive_damage(damage_value)
	player.use_mana(mana_usage)

	descriptor.display_effects(player.player_info.name+" ha fatto "+str(damage_value)+" danni a "+g.boss.boss_info.name+". La difesa del boss cala!")
	
	# Add, if you want, some special effects here
	g.boss.change_def(debuff_def)
	
	always_at_end_attack()

func do_hachi(i_want_to_do_it : bool = true):
	const buff_atk = 300
	
	if not i_want_to_do_it:
		return true
	remove_child(animation)
	g.animation_playing = false
	
	descriptor.display_effects(player.player_info.name+" ha ricordato l`incontro con la sua maestra. Il suo attacco aumenta vertiginosamente.")
	
	# Add, if you want, some special effects here
	player.change_atk(buff_atk)
	always_at_end_attack()

func do_panino(i_want_to_do_it : bool = true):
	const buff_def = 10
	
	if not i_want_to_do_it:
		return true
	remove_child(animation)
	g.animation_playing = false
	
	descriptor.display_effects(player.player_info.name+" si è mangiato un panino. Ha recuperato tutta la vita e si è messo in forze.")
	
	# Add, if you want, some special effects here
	player.set_health(player.player_info.base_hp)
	player.change_def(buff_def)
	always_at_end_attack()

func do_acqua(i_want_to_do_it : bool = true):
	const buff_atk = 40
	if not i_want_to_do_it:
		return true
	remove_child(animation)
	g.animation_playing = false
	
	descriptor.display_effects(player.player_info.name+" ha bevuto da una borraccia d`acqua. Il suo attacco aumenta.")
	
	# Add, if you want, some special effects here
	player.set_mana(player.player_info.base_mana)
	player.change_atk(buff_atk)
	always_at_end_attack()

func do_talismano(i_want_to_do_it : bool = true):
	if not i_want_to_do_it:
		return true
	remove_child(animation)
	g.animation_playing = false
	
	descriptor.display_effects(player.player_info.name+" ha piazzato il talismano. Tutte le statistiche ritornano alla normalità.")
	
	for a_player in g.players:
		a_player.curr_atk = a_player.player_info.base_atk
		a_player.curr_def = a_player.player_info.base_def
		a_player.curr_spe = a_player.player_info.base_spe
		a_player.curr_eva = a_player.player_info.base_eva
	g.boss.curr_atk = g.boss.boss_info.base_atk
	g.boss.curr_def = g.boss.boss_info.base_def
	g.boss.curr_spe = g.boss.boss_info.base_spe
	g.boss.curr_eva = g.boss.boss_info.base_eva
	always_at_end_attack()

func do_liv(i_want_to_do_it : bool = true):
	const damage_multiplyer = 6
	
	if not i_want_to_do_it:
		return true
	remove_child(animation)
	g.animation_playing = false
	
	var damage_value = basic_damage_formula(player.curr_atk, damage_multiplyer, g.boss.curr_def)

	g.boss.receive_damage(damage_value)

	descriptor.display_effects(player.player_info.name+" ha lanciato la sua freccia più potente, causando "+str(damage_value)+" danni a "+g.boss.boss_info.name+".")
	always_at_end_attack()

func do_hideki(i_want_to_do_it : bool = true):
	const buff_atk = 20
	if not i_want_to_do_it:
		return true
	remove_child(animation)
	g.animation_playing = false
	
	descriptor.display_effects(player.player_info.name+" ha ricordato il suo idolo dell`infanzia. Recupera tutta la vita, il mana e aumenta il suo attacco.")
	
	# Add, if you want, some special effects here
	player.set_health(player.player_info.base_health)
	player.set_mana(player.player_info.base_mana)
	player.change_atk(buff_atk)
	always_at_end_attack()

func do_yoku(i_want_to_do_it : bool = true):
	const buff_spe = 90
	if not i_want_to_do_it:
		return true
	remove_child(animation)
	g.animation_playing = false
	
	descriptor.display_effects("Il ricordo di quel furfante di Yoku ha ricordato al gruppo cosa vuole dire perseverare. Aumenta la velocità di tutto il gruppo.")
	
	# Add, if you want, some special effects here
	for a_player in g.players:
		a_player.change_spe(buff_spe)
	always_at_end_attack()

func do_tonfo():
	remove_child(animation)
	g.animation_playing = false
	
	const damage_multiplyer = 1.3
	
	for a_player in g.players:
		var damage_value = basic_damage_formula(player.curr_atk, damage_multiplyer, a_player.curr_def)
		a_player.receive_damage(damage_value)
	
	# Display at the top the result of your action
	descriptor.display_effects(player.boss_info.name+" si è lanciato a tuffo sugli avventurieri. Sono stati tutti colpiti.")
	# You don't need to know what is done here, just put it!
	always_at_end_attack()

func do_morso():
	remove_child(animation)
	g.animation_playing = false
	const debuff_spe = 30
	const damage_multiplyer = 1.2
	
	var damage_value = basic_damage_formula(player.curr_spe, damage_multiplyer, target.curr_spe)
	target.receive_damage(damage_value)
	
	# Display at the top the result of your action
	descriptor.display_effects(player.boss_info.name+" ha morso "+target.player_info.name+" causando "+str(damage_value)+" danni. Il dolore del morso lo rallenta.")
	
	target.change_spe(-debuff_spe)
	
	# You don't need to know what is done here, just put it!
	always_at_end_attack()

func do_ragnatela():
	remove_child(animation)
	g.animation_playing = false
	const debuff_spe = 100
	
	for a_player in g.players:
		a_player.change_spe(-debuff_spe)
	
	# Display at the top the result of your action
	descriptor.display_effects(player.boss_info.name+" ha intrappolato i nostri avventurieri, la loro velocità cala a picco...")
	
	target.change_spe(-debuff_spe)
	
	# You don't need to know what is done here, just put it!
	always_at_end_attack()
