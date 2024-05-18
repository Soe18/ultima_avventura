class_name Boss_Info
extends Resource

# Informazioni generiche di un personaggio
@export_category("Boss Stats")
@export
var name : String = "Stencil"
@export
var base_hp : int = 500
@export
var base_atk : int = 100
@export
var base_def : int = 100
@export
var base_spe : int = 100
@export
var base_eva : int = 5
@export
var param_sprite:Texture2D
@export
var ost:AudioStream
@export_category("Boss abilities")
@export var abilities : Array[String]
