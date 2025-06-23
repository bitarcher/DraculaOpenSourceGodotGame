class_name CurrentlyUsedItemUi
extends HBoxContainer

var _currently_used_item: CurrentlyUsedItem
@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label
@onready var progress_bar: ProgressBar = %ProgressBar

# Supprimez l'affectation dans le setter et utilisez une fonction dédiée
@export var currently_used_item: CurrentlyUsedItem:
	get:
		return _currently_used_item
	set(value):
		_currently_used_item = value
		# Appelez la fonction de mise à jour si le nœud est déjà prêt (dans l'arbre de la scène)
		if is_node_ready(): # Vérifie si _ready() a déjà été appelé
			_update_ui()
			
# Fonction appelée lorsque le nœud entre dans l'arbre de la scène
func _ready() -> void:
	# Initialiser l'UI avec les données actuelles si elles existent
	if _currently_used_item != null:
		_update_ui()

# Fonction pour mettre à jour l'interface utilisateur avec les données de l'objet
func _update_ui():
	# Ces vérifications nulles sont une bonne pratique, même si @onready garantit qu'ils existent après _ready()
	if texture_rect != null:
		texture_rect.texture = _currently_used_item.item.icon
	if label != null:
		label.text = _currently_used_item.item.name
	# progress_bar sera mis à jour dans _process
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Il est crucial de vérifier si _currently_used_item n'est pas nul ici
	# car _process peut être appelé avant que currently_used_item ne soit défini.
	if _currently_used_item != null and progress_bar != null:
		progress_bar.value = 1.0 - _currently_used_item.get_usage_percent()
