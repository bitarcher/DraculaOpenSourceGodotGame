class_name SubTotal
extends Control

@export var item: Item
@onready var invoice: Invoice = get_parent().get_parent()

@onready var item_icon: TextureRect = $HBoxContainer/ItemIcon
@onready var item_name: Label = $HBoxContainer/ItemName
@onready var sell_price_label: Label = $HBoxContainer/SellPrice
@onready var buy_price_label: Label = $HBoxContainer/BuyPrice
@onready var quantity_spinbox: SpinBox = $HBoxContainer/Quantity
@onready var subtotal_label: Label = $HBoxContainer/SubTotalValue

var sell_price: float
var buy_price: float

func _ready() -> void:
	if item:
		item_icon.texture = item.texture
		item_name.text = item.name
		
		sell_price = invoice.get_sell_price(item)
		buy_price = invoice.get_buy_price(item)
		
		sell_price_label.text = str(sell_price)
		buy_price_label.text = str(buy_price)
		
		quantity_spinbox.value_changed.connect(_on_quantity_changed)
		update_subtotal()

func _on_quantity_changed(new_quantity: float) -> void:
	update_subtotal()
	emit_signal("quantity_changed", item, new_quantity)

func update_subtotal() -> void:
	var quantity = quantity_spinbox.value
	var unit_price = sell_price if quantity > 0 else buy_price
	var subtotal = unit_price * abs(quantity)
	subtotal_label.text = str(subtotal)
