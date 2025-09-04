extends Node

## Load in menus that need to be consistent through the game
# --- Scene paths ---
const PATH_JOURNAL    := "res://scenes/ui/Journal.tscn"
const PATH_DICTIONARY := "res://scenes/ui/dictionary.tscn"
##const PATH_PAUSE      := "res://scenes/ui/PauseMenu.tscn"

# --- Instances (persist across scene changes) ---
var _menu_layer: CanvasLayer
var _journal: Control
var _dictionary: Node        # DictionaryView (Control) expected; kept as Node to allow no-class script
#var _pause_menu: Control


var _initialized: bool = false

func _ready() -> void:
	_init_menus()

# ------------- INTERNALS --------------------------
func _init_menus():
	if _initialized:
		return
	_initialized = true
	
	# A dedicated UI layer that survives scene changes and stays on top
	_menu_layer = CanvasLayer.new()
	_menu_layer.name = "MenuLayer"
	_menu_layer.layer = 100
	get_tree().root.add_child.call_deferred(_menu_layer)
	
	# Instance each menu once, add to layer, hide
	_journal   = _instance_menu(PATH_JOURNAL)
	_dictionary = _instance_menu(PATH_DICTIONARY)
	##_pause_menu = _instance_menu(PATH_PAUSE)

func _instance_menu(path: String) -> Control:
	if not ResourceLoader.exists(path):
		push_warning("MenuManager: scene not found: %s" % path)
		return null
	var ps := load(path) as PackedScene
	if ps == null:
		push_warning("MenuManager: failed to load PackedScene: %s" % path)
		return null
	var inst := ps.instantiate()
	if inst is CanvasItem:
		(inst as CanvasItem).visible = false
	_menu_layer.add_child(inst)
	return inst

func _ensure_menus() -> void:
	if not _initialized or _menu_layer == null or not is_instance_valid(_menu_layer):
		_initialized = false
		_init_menus()

# --------------- MENU CONTROLS ------------------------------

func open_journal_menu():
	_ensure_menus()
	_journal.open()

func close_journal_menu():
	_journal.close()


func open_dictionary_menu():
	_ensure_menus()
	_dictionary.open()

func dictionary_search(word: String):
	_dictionary.search_word(word)

func close_dictionary_menu():
	_dictionary.close()
