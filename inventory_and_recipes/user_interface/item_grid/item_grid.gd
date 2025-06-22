class_name ItemGrid
extends GridContainer

@export var slot_scene:PackedScene

@export var has_selection: bool = false

signal selected_item_slot_changed(item_slot: ItemSlot)

func display(items:Array[Item]):
	for child in get_children():
		child.queue_free()
		
	for item in items:
		var slot: ItemSlot = slot_scene.instantiate()
		add_child(slot)
		slot.display(item)
		
		if(has_selection):
			slot.button_pressed.connect(on_slot_button_pressed)

func on_slot_button_pressed(emitter: ItemSlot):
	for child in self.get_children():
		if child is ItemSlot:
			var item_slot = child as ItemSlot
			
			item_slot.is_selected = item_slot == emitter
			
	selected_item_slot_changed.emit(emitter)
