class_name CurrentlyUsedIemsUi
extends Panel

@onready var v_box_container: VBoxContainer = $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManagerSingleton.currently_used_items.cu_items_changed.connect(_cu_items_changed)
	_recreate_content()

func _cu_items_changed():
	_recreate_content()

func _recreate_content():
	print("recreating currently used items ui")
	for child in v_box_container.get_children():
		child.queue_free()
		
	var currently_used_items = GameManagerSingleton.currently_used_items
	
	for currently_used_item in currently_used_items.get_cu_items():
		var currently_used_item_ui = CurrentlyUsedItemUi.new()
		v_box_container.add_child(currently_used_item_ui)
		currently_used_item_ui.currently_used_item = currently_used_item
