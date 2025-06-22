class_name InventoryDialog
extends PanelContainer

@export var slot_scene:PackedScene

@onready var grid_container:ItemGrid = %GridContainer


func open(inventory:Inventory):
	show()
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	grid_container.display(inventory.get_items())
	


func _on_close_button_pressed():
	hide()
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_use_button_pressed() -> void:
	pass # Replace with function body.
