class_name Item
extends Resource

## The name of the item.
@export var name:String

## The icon of the item.
@export var icon:Texture2D

## Shoppe price
@export var price:int = 5

## Instantiates the 2d representation and initializes it with the 
## current item
func instantiate() -> Sprite2D:
	var result = Sprite2D.new()
	
	result.texture = icon
	
	return result
