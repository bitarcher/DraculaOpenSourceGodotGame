class_name InventoryDialog
extends PanelContainer

@export var slot_scene:PackedScene

@onready var grid_container:ItemGrid = %GridContainer
@onready var use_button: Button = %UseButton
var _inventory:Inventory

func open(inventory:Inventory):
	_inventory = inventory
	show()
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	grid_container.display(inventory.get_items())

func _on_close_button_pressed():
	hide()
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_use_button_pressed() -> void:
	var maybe_selected_item_slot = grid_container.get_maybe_selected_item_slot()
	
	if maybe_selected_item_slot != null:
		var item = maybe_selected_item_slot.item
		_inventory.remove_item(item)
		
		GameManagerSingleton.currently_used_items.add_item(item)


func _on_grid_container_selected_item_slot_changed(item_slot: ItemSlot) -> void:
	use_button.disabled = item_slot == null or not item_slot.item.usable
