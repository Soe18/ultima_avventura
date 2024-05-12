extends Control

# Changed because 'continue' it's a key word
@onready var _continue = %Continue
@onready var _save = %Save
@onready var _mainmenu = %MainMenu
@onready var scene_manager = get_parent()

func set_focus():
	_continue.grab_focus()

# Signals press
func _on_continue_pressed():
	scene_manager.continue_game()

func _on_save_pressed():
	scene_manager.save()
	scene_manager.continue_game()

func _on_main_menu_pressed():
	scene_manager.redirect_to_main_menu()
