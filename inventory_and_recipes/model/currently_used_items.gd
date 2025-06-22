class_name CurrentlyUsedItems
extends Resource

signal cu_items_changed()

@export var cu_items: Array[CurrentlyUsedItem]

func add_cu_item(cu_item: CurrentlyUsedItem):
	cu_items.append(cu_item)
	cu_items_changed.emit()
	
func get_cu_items() -> Array[CurrentlyUsedItem]:
	return cu_items
	
func add_item(item: Item):
	var cu_item = CurrentlyUsedItem.new_from_item(item)
	
	add_cu_item(cu_item)

func clear():
	cu_items.clear()
	cu_items_changed.emit()

func check_and_consumed_currently_used_items():
	var to_remove: Array[CurrentlyUsedItem] = []
	var current_ticks = Time.get_ticks_msec()
	
	for cu_item in cu_items:
		if(cu_item.planned_end_ticks < current_ticks):
			to_remove.append(cu_item)
	
	var found: bool = false		
	for cu_item in to_remove:
		cu_items.erase(cu_item)
		found=true
		
	if found:
		cu_items_changed.emit()
