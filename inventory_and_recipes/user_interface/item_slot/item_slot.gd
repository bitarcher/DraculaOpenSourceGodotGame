extends PanelContainer

@onready var _texture_rect:TextureRect = %TextureRect
@onready var label: Label = %Label

func display(item:Item):
	_texture_rect.texture = item.icon
	label.text = item.name
	
