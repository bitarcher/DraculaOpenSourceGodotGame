class_name Inventory
extends Resource

@export var _content:Array[Item] = []

## Add an item to this inventory.
func add_item(to_add:Item):
	_content.append(to_add)

func add_items(to_add:Item, quantity: int):
	for i in range(0, quantity):
		add_item(to_add)

	
## Remove an item from this inventory.	
func remove_item(to_remove:Item):
	_content.erase(to_remove)
	
func remove_items(to_remove:Item, quantity: int):
	for i in range(0, quantity):
		remove_item(to_remove)
	
## Returns all items in this inventory.	
func get_items() -> Array[Item]:
	return _content
	
# used for restoring (load game)
func set_items(items: Array[Item]):
	_content = items

func has_all(items:Array[Item]) -> bool:
	var needed:Array[Item] = items.duplicate()
	for available in _content:
		needed.erase(available)
		
	return needed.is_empty()

func get_item_quantity(item: Item) -> int:
	var count = 0
	for i in _content:
		if i == item:
			count += 1
	return count
