extends Node
class_name DictionaryDB

@export var source_paths: Array[String] = [
	"res://data/dictionaries/dictionary.json" # you can add more shards later
]

# Core stores
var entries: Dictionary = {}              # id -> Dictionary (the raw JSON entry)
var alias_to_id: Dictionary = {}          # alias -> id
var en_sorted_ids: Array[String] = []
var ja_sorted_ids: Array[String] = []

func _ready() -> void:
	load_all()
	build_indexes()

func load_all() -> void:
	entries.clear()
	for p in source_paths:
		var text := FileAccess.get_file_as_string(p)
		if text.is_empty():
			push_warning("DictionaryDB: empty or missing file: %s" % p)
			continue
		var data = JSON.parse_string(text)
		if typeof(data) != TYPE_ARRAY:
			push_error("DictionaryDB: %s is not a JSON array" % p)
			continue
		for e in data:
			if typeof(e) != TYPE_DICTIONARY or not e.has("id"):
				continue
			var id := String(e["id"]).strip_edges().to_lower()
			# Precompute a few normalized fields to speed up search
			e["en_lower"]    = String(e.get("en","")).to_lower()
			e["kana_norm"]   = _kana_norm(String(e.get("ja_kana","")))
			e["romaji_lower"]= String(e.get("romaji","")).to_lower()
			entries[id] = e

func build_indexes() -> void:
	alias_to_id.clear()
	en_sorted_ids.clear()
	ja_sorted_ids.clear()

	for id in entries.keys():
		var e: Dictionary = entries[id]
		# aliases → id
		for a in (e.get("aliases", []) as Array):
			var alias := String(a).to_lower()
			alias_to_id[alias] = id
		# english sort
		en_sorted_ids.append(id)
		# japanese sort (kana)
		ja_sorted_ids.append(id)

	# stable sorts
	en_sorted_ids.sort_custom(func(a, b):
		return entries[a]["en_lower"] < entries[b]["en_lower"]
	)

	ja_sorted_ids.sort_custom(func(a, b):
		return entries[a]["kana_norm"] < entries[b]["kana_norm"]
	)

func has_id(id: String) -> bool:
	return entries.has(id.to_lower())

func get_by_id(id: String) -> Dictionary:
	return entries.get(id.to_lower(), {})

func resolve_any(token: String) -> String:
	# Try id, then alias, then english exact, then kana exact
	var q := token.to_lower()
	if entries.has(q):
		return q
	if alias_to_id.has(q):
		return alias_to_id[q]
	# fallback: exact english match
	for id in entries.keys():
		if entries[id]["en_lower"] == q:
			return id
	# fallback exact kana
	var kn := _kana_norm(token)
	for id in entries.keys():
		if entries[id]["kana_norm"] == kn:
			return id
	return "" # not found

func search(query: String, limit := 50) -> Array[Dictionary]:
	if query.is_empty():
		return []
	var q_lower := query.to_lower()
	var q_kana  := _kana_norm(query)

	var scored: Array = []
	for id in entries.keys():
		var e: Dictionary = entries[id]
		var score := 0

		# exacts
		if e["en_lower"] == q_lower: score = 100
		elif e["kana_norm"] == q_kana: score = max(score, 95)
		elif e["romaji_lower"] == q_lower: score = max(score, 90)
		elif alias_to_id.get(q_lower, "") == id: score = max(score, 85)

		# begins_with
		if score == 0:
			if e["en_lower"].begins_with(q_lower): score = 80
			elif e["kana_norm"].begins_with(q_kana): score = 75
			elif e["romaji_lower"].begins_with(q_lower): score = 70

		# contains (simple full-text across example sentences too)
		if score == 0:
			if e["en_lower"].find(q_lower) != -1: score = 60
			elif e["kana_norm"].find(q_kana) != -1: score = 55
			elif e["romaji_lower"].find(q_lower) != -1: score = 50
			else:
				for ex in (e.get("examples", []) as Array):
					if String(ex.get("en","")).to_lower().find(q_lower) != -1:
						score = 40; break
					if _kana_norm(String(ex.get("ja",""))).find(q_kana) != -1:
						score = 40; break

		if score > 0:
			scored.append({ "score": score, "e": e })

	scored.sort_custom(func(a, b): return a["score"] > b["score"])
	var out: Array[Dictionary] = []
	for i in min(limit, scored.size()):
		out.append(scored[i]["e"])
	return out

func get_all_sorted(field: String) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	var ids := en_sorted_ids if field == "en" else ja_sorted_ids
	for id in ids:
		out.append(entries[id])
	return out

static func _kana_norm(s: String) -> String:
	# katakana → hiragana, lowercase-ish normalization for simple matching
	var sb := ""
	for ch in s:
		var c := ch.unicode_at(0)
		# Katakana block → Hiragana (offset 0x60)
		if c >= 0x30A1 and c <= 0x30F6:
			sb += char(c - 0x60)
		else:
			sb += ch
	return sb.strip_edges()
