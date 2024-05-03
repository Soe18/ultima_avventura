extends Control

# Changed because 'continue' it's a key word
@onready var _continue = %Continue
@onready var _load = %Load
@onready var _save = %Save
@onready var _maimmenu = %MainMenu
@onready var scenemanager = get_parent()

func set_focus():
	_continue.grab_focus()

# Signals press
func _on_continue_pressed():
	scenemanager.continue_game()

func _on_load_pressed():
	scenemanager.continue_game()

func _on_save_pressed():
	scenemanager.continue_game()

func _on_main_menu_pressed():
	# TODO: Redirect main menu
	get_tree().quit()
