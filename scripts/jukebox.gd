extends Node

@onready var sfx_cancel = $sfx_cancel
@onready var sfx_move = $sfx_move
@onready var sfx_confirm = $sfx_confirm
@onready var sfx_menu = $sfx_menu
@onready var sfx_hit = $sfx_hit
@onready var sfx_won = $sfx_won
@onready var sfx_lose = $sfx_lose

func _process(delta):
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_down"):
		sfx_move.play()
