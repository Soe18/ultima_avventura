class_name Itemlist
extends Resource

@export var itemlist : Array
var apparent_deletion : Array

func arrify() -> Array:
	print_debug(apparent_deletion)
	removify("-")
	itemlist.sort_custom(func(a, b): return b=="-")
	return itemlist

func del_item(item):
	itemlist.erase(item)
	apparent_deletion.append(item)

func confirm_del_item(item):
	apparent_deletion.erase(item)

func return_items():
	itemlist.append_array(apparent_deletion)
	apparent_deletion = []

func restore_just_last_item():
	if len(apparent_deletion)>0:
		itemlist.append(apparent_deletion.pop_back())
	# else there's nothing to return...

# This method shouldn't exists, but it's the easiest fix for now
func removify(to_remove):
	for item in itemlist:
		if item == to_remove:
			itemlist.erase(item)
