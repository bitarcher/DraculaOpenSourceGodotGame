class_name ItemSlot
extends PanelContainer

var _is_selected: bool = false
@onready var button: Button = %Button

signal button_pressed(emitter: ItemSlot)

@export var item: Item

@export var is_selected: bool:
	set(value):
		_is_selected = value
		if value:
			modulate = Color.RED
		else:
			modulate = Color.WHITE
	get:
		return _is_selected

func display(item:Item):
	button.icon = item.icon
	button.text = item.name
	self.item = item 	
	

func _on_button_pressed() -> void:
	print("ItemSlot.button pressed")
	button_pressed.emit(self)
