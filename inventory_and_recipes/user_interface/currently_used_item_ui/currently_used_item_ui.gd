class_name CurrentlyUsedItemUi
extends HBoxContainer

var _currently_used_item: CurrentlyUsedItem
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $VBoxContainer/Label
@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar

@export var currently_used_item: CurrentlyUsedItem:
	get:
		return _currently_used_item
	set(value):
		_currently_used_item = value
		texture_rect.texture = _currently_used_item.item.icon
		label.text = _currently_used_item.item.name
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value = _currently_used_item.get_usage_percent()
