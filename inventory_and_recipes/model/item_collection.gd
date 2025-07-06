class_name ItemCollection
extends Resource

## The name of the item collections
@export var name:String


@export var items: Array[Item] = []

static func create(name: String) -> ItemCollection:
	var result = ItemCollection.new()
	result.name = name
	
	return result
