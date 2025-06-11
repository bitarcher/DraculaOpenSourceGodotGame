extends HBoxContainer

# Références aux nœuds Label dans la scène UI.
# L'utilisation de '%' est une fonctionnalité Godot 4 appelée "unique node names"
# qui facilite l'accès aux nœuds.
@onready var rank_label = %RankLabel
@onready var name_label = %NameLabel
@onready var coins_label = %CoinsLabel
@onready var level_label = %LevelLabel
@onready var lives_label = %LivesLabel

# Méthode pour mettre à jour l'affichage de cet élément UI avec les données d'un OrderedHighScoreItem.
func set_item_data(ordered_item: OrderedHighScoreItem) -> void:
	# Vérifie si l'élément et ses données HighScoreItem sont valides.
	if ordered_item and ordered_item.item:
		rank_label.text = str(ordered_item.get_position_one_based()) + "." # Rang 1-basé
		name_label.text = ordered_item.item.player_name
		coins_label.text = "%d coins" % ordered_item.item.num_of_coins
		level_label.text = "Lev. %d" % ordered_item.item.max_level
		lives_label.text = "%d liv." % ordered_item.item.remaining_lives
	else:
		# En cas de données invalides ou manquantes, afficher un état par défaut.
		rank_label.text = ""
		name_label.text = "N/A"
		coins_label.text = ""
		level_label.text = ""
		lives_label.text = ""
