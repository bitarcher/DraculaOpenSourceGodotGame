class_name CurrentlyUsedItemSavedData
extends SavedData

@export var item: Item
@export var usage_percent: float # from 0.0 to 1.0

func from_currently_used_item(currently_used_item: CurrentlyUsedItem):
	item = currently_used_item.item
	var current_ticks = Time.get_ticks_msec()
	var used_ticks = (current_ticks - currently_used_item.start_ticks) * 1.0
	var total_ticks = (currently_used_item.planned_end_ticks - currently_used_item.start_ticks) * 1.0
	usage_percent = used_ticks / total_ticks
	
func to_currently_used_item() -> CurrentlyUsedItem:
	var result: CurrentlyUsedItem = CurrentlyUsedItem.new()
	
	result.item = item
	var current_ticks = Time.get_ticks_msec()
	var item_duration_in_milliseconds = item.duration_in_seconds * 1000
	var used_ticks = item_duration_in_milliseconds * usage_percent
	result.start_ticks = current_ticks - used_ticks
	result.planned_end_ticks = result.start_ticks + item_duration_in_milliseconds
	
	return result
