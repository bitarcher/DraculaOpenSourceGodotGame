class_name Invoice
extends Control

@export var inside_shop: InsideShop

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var subtotal_container: VBoxContainer = $VBoxContainer/ScrollContainer/SubTotalContainer
@onready var total_value_label: Label = $VBoxContainer/TotalsVBox/TotalHBox/TotalValueLabel
@onready var diamonds_before_value_label: Label = $VBoxContainer/TotalsVBox/DiamondsBeforeHBox/DiamondsBeforeValueLabel
@onready var diamonds_after_value_label: Label = $VBoxContainer/TotalsVBox/DiamondsAfterHBox/DiamondsAfterValueLabel
@onready var ok_button: Button = $VBoxContainer/ButtonsHBox/OkButton
@onready var cancel_button: Button = $VBoxContainer/ButtonsHBox/CancelButton

var sub_total_scene = preload("res://inventory_and_recipes/user_interface/sub_total/sub_total.tscn")
var item_collections_scene = preload("res://inventory_and_recipes/data/item_collections.tscn")

var game_manager
var item_collections

func _ready() -> void:
	game_manager = get_node("/root/GameManager")
	item_collections = item_collections_scene.instantiate()

	ok_button.pressed.connect(_on_ok_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)

	if inside_shop:
		_populate_invoice()

func _populate_invoice() -> void:
	_set_title()
	var items = _get_item_list_for_shop()
	for item in items:
		var sub_total_instance = sub_total_scene.instantiate()
		sub_total_instance.item = item
		sub_total_instance.quantity_changed.connect(_on_sub_total_quantity_changed)
		subtotal_container.add_child(sub_total_instance)
	
	_update_totals()

func _set_title() -> void:
	var shop_type_str = AShop.EnumShopType.keys()[inside_shop.shop.shop_type].to_lower()
	var character_name = "Unknown"
	for c in inside_shop.all_characters:
		if c.num == inside_shop.shop.character_id and c.shop_type == inside_shop.shop.shop_type:
			character_name = c.name
			break
	title_label.text = "%s %s - Invoice" % [shop_type_str.capitalize(), character_name]

func _get_item_list_for_shop() -> Array[Item]:
	match inside_shop.shop.shop_type:
		AShop.EnumShopType.GROCERY:
			return item_collections.grocery_item_collection.items
		AShop.EnumShopType.BLACKSMITH:
			return item_collections.blacksmith_item_collection.items
		AShop.EnumShopType.APOTHECARY:
			return item_collections.apothecary_item_collection.items
	return []

func _on_sub_total_quantity_changed(item, quantity) -> void:
	_update_totals()

func _update_totals() -> void:
	var total = 0.0
	for sub_total in subtotal_container.get_children():
		var quantity = sub_total.quantity_spinbox.value
		var unit_price = sub_total.sell_price if quantity > 0 else sub_total.buy_price
		total += unit_price * abs(quantity)
	
	total_value_label.text = str(total)
	
	var diamonds_before = game_manager.get_num_of_diamonds()
	diamonds_before_value_label.text = str(diamonds_before)
	
	var diamonds_after = diamonds_before - total
	diamonds_after_value_label.text = str(diamonds_after)
	
	ok_button.disabled = diamonds_after < 0

func _on_ok_pressed() -> void:
	var total_cost = float(total_value_label.text)
	var current_diamonds = game_manager.get_num_of_diamonds()
	game_manager.set_num_of_diamonds(current_diamonds - total_cost)

	for sub_total in subtotal_container.get_children():
		var quantity = int(sub_total.quantity_spinbox.value)
		var item = sub_total.item
		if quantity > 0:
			game_manager.inventory.add_item(item, quantity)
		elif quantity < 0:
			game_manager.inventory.remove_item(item, abs(quantity))

	inside_shop.hide_menu()

func _on_cancel_pressed() -> void:
	inside_shop.hide_menu()

func get_sell_price(item: Item) -> float:
	assert(item != null)
	assert(inside_shop != null)
	var trade_margin_percent : int = inside_shop.shop.trade_margin
	var market_price: float = item.price
	var margin : float = market_price / 100.0 * trade_margin_percent
	var result = market_price + margin
	return result

func get_buy_price(item: Item) -> float:
	assert(item != null)
	assert(inside_shop != null)
	var trade_margin_percent : int = inside_shop.shop.trade_margin
	var market_price: float = item.price
	var margin : float = market_price / 100.0 * trade_margin_percent
	var result = market_price - margin
	return result
