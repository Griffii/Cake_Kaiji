extends Control
class_name DictionaryView
## Requires an autoload named `DictionaryManager` with:
##   resolve_any(q: String) -> String
##   get_by_id(id: String) -> Dictionary
##   search(q: String, limit := 50) -> Array[Dictionary]

# --- Hook up these paths in the Inspector ---
@export var english_label_path: NodePath
@export var furigana_label_path: NodePath
@export var japanese_label_path: NodePath
@export var type_label_path: NodePath
@export var explanation_label_path: NodePath
@export var en_aliases_label_path: NodePath
@export var jp_aliases_label_path: NodePath
@export var examples_label_path: NodePath  # RichTextLabel recommended

# --- Cached nodes ---
@onready var _english  : Label          = get_node(english_label_path)
@onready var _furigana : Label          = get_node(furigana_label_path)
@onready var _japanese : Label          = get_node(japanese_label_path)
@onready var _type     : Label          = get_node(type_label_path)
@onready var _explanation : RichTextLabel = get_node(explanation_label_path)
@onready var _en_aliases  : Label       = get_node(en_aliases_label_path)
@onready var _jp_aliases : Label        = get_node(jp_aliases_label_path)
@onready var _examples : RichTextLabel  = get_node(examples_label_path) as RichTextLabel

@onready var anim_player = $AnimationPlayer

var _ready_ok := false
var _queued_word := ""

# Colors for each part of speech
const COLOR_NOUN       = Color("#4CAF50")  # Green
const COLOR_VERB       = Color("#2196F3")  # Blue
const COLOR_ADJECTIVE  = Color("#E91E63")  # Pink
const COLOR_ADVERB     = Color("#9C27B0")  # Purple
const COLOR_PRONOUN    = Color("#FF9800")  # Orange
const COLOR_PREPOSITION= Color("#009688")  # Teal
const COLOR_CONJUNCTION= Color("#3F51B5")  # Indigo
const COLOR_INTERJECTION=Color("#F44336")  # Red
const COLOR_DETERMINER = Color("#795548")  # Brown
const COLOR_PHRASE     = Color("#607D8B")  # Gray

const POS_JA := {
	"noun": "名詞",
	"verb": "動詞",
	"adjective": "形容詞",
	"adverb": "副詞",
	"pronoun": "代名詞",
	"preposition": "前置詞",
	"conjunction": "接続詞",
	"interjection": "間投詞",
	"determiner": "限定詞",
	"phrase": "表現",
}

# English key -> color (you already have these COLOR_* constants)
const POS_COLOR := {
	"noun": COLOR_NOUN,
	"verb": COLOR_VERB,
	"adjective": COLOR_ADJECTIVE,
	"adverb": COLOR_ADVERB,
	"pronoun": COLOR_PRONOUN,
	"preposition": COLOR_PREPOSITION,
	"conjunction": COLOR_CONJUNCTION,
	"interjection": COLOR_INTERJECTION,
	"determiner": COLOR_DETERMINER,
	"phrase": COLOR_PHRASE,
}


func _ready() -> void:
	_ready_ok = true
	if _queued_word != "":
		var w := _queued_word
		_queued_word = ""
		search_word(w)

func clear_fields() -> void:
	if _english:  _english.text = ""
	if _furigana: _furigana.text = ""
	if _japanese: _japanese.text = ""
	if _type:     _type.text = ""
	if _explanation: _explanation.text = ""
	if _en_aliases:  _en_aliases.text = ""
	if _jp_aliases: _jp_aliases.text = ""
	if _examples:
		_examples.bbcode_enabled = true
		_examples.text = ""

func show_not_found(query: String) -> void:
	if _english:  _english.text = query
	if _furigana: _furigana.text = ""
	if _japanese: _japanese.text = "—"
	if _type:     _type.text = "Not found"
	if _explanation: _explanation.text = ""
	if _en_aliases:  _en_aliases.text = ""
	if _jp_aliases: _jp_aliases.text = ""
	if _examples:
		_examples.text = "[i]No entry found.[/i]"


func _normalize_pos_key(raw: String) -> String:
	var s := raw.strip_edges()
	var sl := s.to_lower()
	if POS_COLOR.has(sl):
		return sl
	return ""


func show_entry(e: Dictionary) -> void:
	# Core fields
	_english.text   = String(e.get("en", ""))
	_japanese.text  = String(e.get("ja_kanji", ""))
	var kana_val    = e.get("ja_kana", null)
	_furigana.text = ""
	if kana_val != null:
		_furigana.text = String(kana_val)
	_explanation.text = String(e.get("ja_expl", ""))
	
	# Part of speech + color (EN->JA label)
	var raw_pos := String(e.get("pos", "")).strip_edges()
	var key := _normalize_pos_key(raw_pos)
	
	var pos_color := Color.WHITE
	var ja_label := raw_pos  # default: show original if unknown
	
	if key != "":
		pos_color = POS_COLOR.get(key, Color.WHITE)
		ja_label = POS_JA.get(key, raw_pos)
	
	_type.add_theme_color_override("font_color", pos_color)
	_type.text = ja_label
	
	# Aliases (manual join)
	var en_aliases: Array = e.get("eng_aliases", []) as Array
	var en_out := ""
	for i in en_aliases.size():
		if i > 0: en_out += ", "
		en_out += String(en_aliases[i])
	_en_aliases.text = en_out
	
	var jp_aliases: Array = e.get("jpn_aliases", []) as Array
	var jp_out := ""
	for i in jp_aliases.size():
		if i > 0: jp_out += "、"
		jp_out += String(jp_aliases[i])
	_jp_aliases.text = jp_out
	
	# Examples (manual join)
	_examples.bbcode_enabled = true
	var ex_arr: Array = e.get("examples", []) as Array
	if ex_arr.is_empty():
		_examples.text = "[i](no examples)[/i]"
	else:
		var sb := ""
		for i in ex_arr.size():
			if i > 0: sb += "\n\n"
			var ex: Dictionary = ex_arr[i]
			sb += "• %s\n   %s" % [String(ex.get("en","")), String(ex.get("ja",""))]
		_examples.text = sb



func open():
	SceneManager.in_menu = true
	anim_player.play("open_dictionary")

func close():
	SceneManager.in_menu = false
	anim_player.play("close_dictionary")

func close_btn_pressed():
	MenuManager.close_dictionary_menu()

# SceneManager calls this when a vocab word is clicked
func search_word(word: String) -> void:
	if not _ready_ok:
		# If SceneManager calls before _ready, queue it.
		_queued_word = word
		return
	
	var q := String(word).strip_edges()
	clear_fields()
	if q.is_empty():
		show_not_found("")
		return
	
	var id := ""
	var entry: Dictionary = {}
	if id != "":
		entry = DictionaryManager.get_by_id(id)
	else:
		# 2) Fall back to a normal search and take the top hit.
		var results: Array = DictionaryManager.search(q, 1)
		if results.size() > 0:
			entry = results[0]
	
	if entry.is_empty():
		show_not_found(q)
		return
	
	show_entry(entry)
