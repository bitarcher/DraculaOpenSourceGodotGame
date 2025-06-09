class_name HighScoreItems
extends Resource

const MAX_SAVED_NUM_OF_ITEM = 10 # Définit le nombre maximum d'éléments de score élevé à conserver.

@export var items: Array[HighScoreItem] = []

func get_ordered_highscore_items() -> Array[OrderedHighScoreItem]:
	# Crée une copie superficielle du tableau pour ne pas modifier l'original.
	var items_to_sort: Array[HighScoreItem] = items.duplicate()

	# Trie les éléments en utilisant une fonction de comparaison personnalisée.
	items_to_sort.sort_custom(_compare_high_score_items)

	var ordered_list: Array[OrderedHighScoreItem] = []
	for i in range(items_to_sort.size()):
		var high_score_item: HighScoreItem = items_to_sort[i]
		var ordered_item = OrderedHighScoreItem.new(high_score_item, i)
		ordered_list.append(ordered_item)
	
	return ordered_list

# Fonction de comparaison pour le tri.
# Elle retourne `true` si `a` doit être trié avant `b`.
# La priorité du tri est :
# 1. num_of_coins (décroissant)
# 2. max_level (décroissant)
# 3. remaining_lives (décroissant)
func _compare_high_score_items(a: HighScoreItem, b: HighScoreItem) -> bool:
	# Comparaison par num_of_coins (plus de pièces = meilleur)
	if a.num_of_coins != b.num_of_coins:
		return a.num_of_coins > b.num_of_coins # Tri décroissant pour les pièces

	# Si num_of_coins est égal, comparer par max_level (niveau plus élevé = meilleur)
	if a.max_level != b.max_level:
		return a.max_level > b.max_level # Tri décroissant pour le niveau

	# Si num_of_coins et max_level sont égaux, comparer par remaining_lives (plus de vies = meilleur)
	return a.remaining_lives > b.remaining_lives # Tri décroissant pour les vies

# Tente d'ajouter un nouvel HighScoreItem à la liste.
# Retourne true si l'élément a été ajouté (ou a remplacé un score plus bas), false sinon.
func add_highscore_item_if_possible(new_highscore_item: HighScoreItem) -> bool:
	# Assurez-vous que la liste est triée avant toute opération.
	# Le tri est important pour savoir si le nouveau score est éligible ou si un ancien doit être remplacé.
	items.sort_custom(_compare_high_score_items)

	# Si la liste n'est pas pleine, ajoutez le nouveau score.
	if items.size() < MAX_SAVED_NUM_OF_ITEM:
		items.append(new_highscore_item)
		items.sort_custom(_compare_high_score_items) # Retrier après l'ajout
		return true
	else:
		# La liste est pleine. Vérifiez si le nouveau score est meilleur que le plus bas.
		# Puisque la liste est triée en ordre décroissant, le dernier élément est le plus bas.
		var lowest_score: HighScoreItem = items[items.size() - 1]

		# Si le nouveau score est meilleur que le score le plus bas actuel
		if _compare_high_score_items(new_highscore_item, lowest_score):
			items[items.size() - 1] = new_highscore_item # Remplace le score le plus bas
			items.sort_custom(_compare_high_score_items) # Retrier après remplacement
			return true
		else:
			# Le nouveau score n'est pas assez bon pour entrer dans le classement.
			return false
