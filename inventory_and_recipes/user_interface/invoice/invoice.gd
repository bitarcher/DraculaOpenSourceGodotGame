class_name Invoice
extends Control


@export var inside_shop: InsideShop

func get_vendor_sell_price(subtotal: SubTotal) -> float:
	
	assert(subtotal != null)
	
	assert(subtotal.item != null)
	
	assert(inside_shop != null)
	
	var trade_margin_percent : int = inside_shop.shop.trade_margin
	
	var market_price: float = subtotal.item.price
	
	var margin : float = market_price / 100.0 * trade_margin_percent
	
	var result = market_price + margin
	
	return result

func get_vendor_buy_price(subtotal: SubTotal) -> float:
	
	assert(subtotal != null)
	
	assert(subtotal.item != null)
	
	assert(inside_shop != null)
	
	var trade_margin_percent : int = inside_shop.shop.trade_margin
	
	var market_price: float = subtotal.item.price
	
	var margin : float = market_price / 100.0 * trade_margin_percent
	
	var result = market_price - margin
	
	return result


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
