extends Node

### HOW TO USE FLAG SYSTEM ###
## Mark Yuka's room as visited
# GameFlags.set_flag("rooms/yukas_room/visited", true)
#
## Check if Sosuke knows the secret
# if GameFlags.get_flag("story/knows_yuka_secret"):
#	print("He knows!")
#
## Increment visits
# var visit_count = GameFlags.get_flag("rooms/yukas_room/visit_count") or 0
# GameFlags.set_flag("rooms/yukas_room/visit_count", visit_count + 1)

var flags = {
	"rooms": {
		"bathroom": { "visited": false, "visit_count": 0 },
		"garage": { "visited": false, "visit_count": 0 },
		"grandparents_room": { "visited": false, "visit_count": 0 },
		"hallway": { "visited": false, "visit_count": 0 },
		"kitchen": { "visited": false, "visit_count": 0 },
		"laundry": { "visited": false, "visit_count": 0 },
		"living_room": { "visited": false, "visit_count": 0 },
		"office": { "visited": false, "visit_count": 0 },
		"parents_room": { "visited": false, "visit_count": 0 },
		"shed": { "visited": false, "visit_count": 0 },
		"sosukes_room": { "visited": false, "visit_count": 0 },
		"yard": { "visited": false, "visit_count": 0 },
		"yukas_room": { "visited": false, "visit_count": 0, "kicked_out": false }
	},
	
	"story": {
		"found_all_cake_pieces": false
	}
}

### Tracks unique IDs of all viewed dialogue conversations
var viewed_dialogues: Dictionary = {}


func get_flag(path: String) -> Variant:
	var keys = path.split("/")
	var ref = flags
	for key in keys:
		if ref.has(key):
			ref = ref[key]
		else:
			return null
	return ref

func set_flag(path: String, value) -> void:
	var keys = path.split("/")
	var ref = flags
	for i in range(keys.size() - 1):
		if not ref.has(keys[i]):
			ref[keys[i]] = {}
		ref = ref[keys[i]]
	ref[keys[-1]] = value
