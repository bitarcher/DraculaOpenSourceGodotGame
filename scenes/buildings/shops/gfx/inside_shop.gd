extends Node2D

var _shop: AShop
@onready var front_of_shop_and_door_node_2d_container: Node2D = %FrontOfShopAndDoorNode2DContainer

@export var shop: AShop:
	set(value):
		_shop = value
		if value != null:
			match value.shop_type:
				AShop.EnumShopType.BLACKSMITH:
					front_of_shop_and_door_node_2d_container.scale.x = -1
				_:
					front_of_shop_and_door_node_2d_container.scale.x = 1
		
	get():
		return _shop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
