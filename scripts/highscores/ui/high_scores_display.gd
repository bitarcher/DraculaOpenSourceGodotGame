extends PanelContainer

# Exportation de la ressource HighScoreItems. Cela permet d'assigner
# une instance de HighScoreItems (soit une nouvelle, soit une ressource sauvegardée)
# directement dans l'inspecteur de l'éditeur Godot.
@export var high_score_data: HighScoreItems

# Référence au conteneur VBoxContainer où les éléments UI de score seront ajoutés.
@onready var items_container = %ItemsContainer

# Chemin vers la scène UI d'un seul élément de score.
# IMPORTANT : ASSUREZ-VOUS QUE CE CHEMIN CORRESPOND BIEN À L'EMPLACEMENT
# DE VOTRE FICHIER ordered_highscore_item_ui.tscn DANS VOTRE PROJET !
const HIGH_SCORE_ITEM_UI_PATH = "res://scenes/highscores/ui/ordered_highscore_item_ui.tscn"

var high_score_item_ui_scene: PackedScene # Variable pour stocker la scène chargée.

func _ready():
	# Charge la scène de l'élément UI une seule fois au démarrage.
	# C'est plus performant que de la charger à chaque fois qu'un élément est créé.
	high_score_item_ui_scene = load(HIGH_SCORE_ITEM_UI_PATH)
	if not high_score_item_ui_scene:
		# Affiche une erreur si la scène n'a pas pu être chargée, ce qui indique un problème de chemin.
		push_error("Erreur: Impossible de charger la scène UI de l'élément de score: %s" % HIGH_SCORE_ITEM_UI_PATH)
		return

	# Met à jour l'affichage des scores dès que la scène est prête.
	_update_display()

# Méthode privée pour gérer la mise à jour de l'affichage des scores.
func _update_display():
	# Supprime tous les éléments de score UI existants pour rafraîchir l'affichage.
	# Cela est utile si les données de score sont mises à jour et que la liste doit être reconstruite.
	for child in items_container.get_children():
		child.queue_free() # Libère l'enfant de la mémoire.

	# Vérifie si la ressource HighScoreItems a été assignée.
	if not high_score_data:
		print("Attention: Aucune donnée de score élevée (HighScoreItems) assignée à la propriété 'high_score_data'.")
		return

	# Récupère la liste des scores ordonnés depuis la ressource HighScoreItems.
	var ordered_items = high_score_data.get_ordered_highscore_items()

	# Pour chaque élément de score ordonné, crée une nouvelle instance de l'UI et l'ajoute.
	for ordered_item in ordered_items:
		if ordered_item and ordered_item.item: # S'assure que l'élément et son contenu ne sont pas nuls
			var high_score_ui_instance = high_score_item_ui_scene.instantiate() # Crée une instance de la scène UI.
			items_container.add_child(high_score_ui_instance) # Ajoute l'instance au conteneur vertical.
			high_score_ui_instance.set_item_data(ordered_item) # Passe les données à l'instance UI pour qu'elle s'affiche.

# Méthode publique pour rafraîchir manuellement l'affichage si les données de score changent
# après que la scène a été chargée (par exemple, après avoir ajouté un nouveau score via `add_highscore_item_if_possible`).
func refresh_display():
	_update_display()
