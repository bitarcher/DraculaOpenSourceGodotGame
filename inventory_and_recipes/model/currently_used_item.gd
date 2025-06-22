class_name CurrentlyUsedItem
extends Resource

@export var item: Item

@export var start_ticks: float
@export var planned_end_ticks: float

func _init() -> void:
	pass
	
static func new_from_item(item: Item) -> CurrentlyUsedItem:
	var result: CurrentlyUsedItem = CurrentlyUsedItem.new()
	result.item =item
	result.start_ticks = Time.get_ticks_usec()
	result.planned_end_ticks = result.start_ticks + item.duration_in_seconds * 1000.0
	
	return result
