extends Node2D

@export var param_sprite:Texture2D
@onready var sprite = %DefaultSprite
@onready var healthbar = %HealthBar

@export_category("Boss Stats")
@export
var boss_name : String = "GenericBoss"
@export
var base_hp : int = 100
@export
var base_atk : int = 100
@export
var base_def : int = 100
@export
var base_spe : int = 110
@export
var base_eva : int = 5

var curr_hp = base_hp
var curr_atk = base_atk
var curr_def = base_def
var curr_spe = base_spe
var curr_eva = base_eva

func _ready():
	# Assegna l'immagine allo sprite
	sprite.texture = param_sprite
	# Centra l'immagine del boss nello schermo
	var size = param_sprite.get_size()
	var viewport = get_viewport().size
	sprite.position.x = viewport.x/2
	sprite.position.y = viewport.y/2
	healthbar.max_value = base_hp
	healthbar.value = base_hp

func _process(delta):
	pass

# diff identifica la differenza
# Se è un valore negativo, recupera vita
func change_health(diff):
	curr_hp = curr_hp-diff
	healthbar.value = curr_hp
