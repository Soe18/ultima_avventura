class_name Player_Info
extends Resource

# Informazioni generiche di un personaggio
@export_category("Player Stats")
@export
var player_name : String = "Stencil"
@export
var base_hp : int = 100
@export
var base_mana : int = 100
@export
var base_atk : int = 100
@export
var base_def : int = 100
@export
var base_spe : int = 100
@export
var base_eva : int = 5

# Change onto a well-done object (DON'T DO ANYTHING, WORK IN PROGRESS)
# Non verrà implementato
var emotion = "neutral"

@export_category("Player Utils")

# Permette di scegliere sia l'ordine di scelta della mossa che di visualizzazione
# L'ordine in CARD_POSITION indica l'ordine di azione (AHAHAHAHAH NO)
enum CARD_POSITION {BOTTOM_LEFT, TOP_LEFT,BOTTOM_RIGHT, TOP_RIGHT}
@export var card_position: CARD_POSITION

# Azioni possibili, sono uguali tra tutti i pg
const menu = ["Combatti", "Recupero", "Strumenti", "Memoria"]

# Dizionario che contiene tutte le abilità univoche
@export
var submenu = {"Combatti":["A","B"],
				"Memoria":["C","D"]}
