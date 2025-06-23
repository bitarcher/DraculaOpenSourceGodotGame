# currently_used_items_ui.gd
class_name CurrentlyUsedIemsUi # <-- Attention à la faute de frappe "Iems" au lieu de "Items" si ce n'est pas intentionnel
extends Panel

@onready var v_box_container: VBoxContainer = $VBoxContainer

# Chargez votre scène CurrentlyUsedItemUi comme une PackedScene
# Assurez-vous que le chemin est correct !
const CURRENTLY_USED_ITEM_UI_SCENE = preload("res://inventory_and_recipes/user_interface/currently_used_item_ui/currently_used_item_ui.tscn")

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
		# C'est la ligne clé qui change !
		var currently_used_item_ui_instance = CURRENTLY_USED_ITEM_UI_SCENE.instantiate()
		
		# Assurez-vous de caster l'instance si vous utilisez le class_name pour le typage fort,
		# ou simplement laissez-le comme un Node (CurrentlyUsedItemUi est son class_name)
		var currently_used_item_ui: CurrentlyUsedItemUi = currently_used_item_ui_instance as CurrentlyUsedItemUi
		
		currently_used_item_ui.currently_used_item = currently_used_item # Ceci appelle le setter maintenant correctement
		v_box_container.add_child(currently_used_item_ui)
