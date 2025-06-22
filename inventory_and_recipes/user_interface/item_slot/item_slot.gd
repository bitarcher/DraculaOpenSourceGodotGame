class_name ItemSlot
extends PanelContainer

@onready var _texture_rect:TextureRect = %TextureRect
@onready var label: Label = %Label
@onready var color_rect: ColorRect = %ColorRect

var _is_selected: bool = false

signal button_pressed(emitter: ItemSlot)

@export var item: Item

@export var is_selected: bool:
	set(value):
		_is_selected = value
		if value:
			modulate = Color.RED
			color_rect.color = Color.RED
		else:
			modulate = Color.WHITE
			color_rect.color = Color.GRAY
	get:
		return _is_selected

func display(item:Item):
	_texture_rect.texture = item.icon
	label.text = item.name
	self.item = item 	
	

func _on_button_pressed() -> void:
	print("ItemSlot.button pressed")
	button_pressed.emit(self)
