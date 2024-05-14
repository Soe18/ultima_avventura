extends Node2D

# Name every animations EXACTLY like 
var default_animation_pos = "res://assets/animations/"
var animation
@onready var g = get_parent() # Stands for gameplay
@onready var descriptor = %Descriptor
@onready var anim_cooldown = %AnimationCooldown
var player

func always_at_end_attack():
	anim_cooldown.start()

func _on_animation_cooldown_timeout():
	g.timeout_text = true
	anim_cooldown.stop()

# Main func which applies the method given the ability
func do_ability(user):
	player = user
	user.curr_sel = "Fuoca"
	play_anim(user.curr_sel)
	# Which effect will be selected?
	match user.curr_sel:
		"Fuoca":
			animation.animation_finished.connect(do_fuoca)
		"Tuonaga":
			animation.animation_finished.connect(do_fuoca)
		"Fulmato":
			animation.animation_finished.connect(do_fuoca)
		"Elira":
			animation.animation_finished.connect(do_fuoca)
		"Distrai":
			animation.animation_finished.connect(do_fuoca)
		"Egida":
			animation.animation_finished.connect(do_fuoca)

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

# Effect
func do_fuoca():
	remove_child(animation)
	g.animation_playing = false
	descriptor.display_effects("Whoa! Arata ha fatto un casino di danni!")
	g.boss.receive_damage(player.curr_atk)
	
	# To always put at your end attack
	always_at_end_attack()

"""
# fighting methods
func general_damage(entity):
	if (!is_boss(entity)):
		boss.change_health(entity.curr_atk)
	else:
		var lucky_one = players.pick_random()
		lucky_one.change_health(entity.curr_atk)
"""
