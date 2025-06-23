class_name EnterPlayerName
extends Panel

@onready var text_edit: TextEdit = %TextEdit

signal player_entered(player_name: String)

func _on_text_edit_gui_input(event: InputEvent) -> void:
	# Vérifie si l'événement est une touche pressée
	if event is InputEventKey:
		# Vérifie si la touche pressée est 'Entrée' (ou 'Entrée' du pavé numérique)
		# et que la touche vient juste d'être pressée (pas relâchée ni une répétition)
		if event.pressed and not event.echo and (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER):
			print("L'utilisateur a appuyé sur Entrée dans le TextEdit !")
			
			if(text_edit.text.length() > 0):
				
				
				# Ici, vous pouvez ajouter votre logique :
				# - Récupérer le texte : var texte_saisi = text
				# - Traiter le texte
				# - Effacer le TextEdit : text = ""
				# - Déplacer le focus, etc.
				
				# Important : Marquer l'événement comme "traité" pour éviter qu'il ne se propage à d'autres contrôles.
				# Utile si vous ne voulez pas qu'un autre nœud parent réagisse aussi à cette touche.
				accept_event()
				print("L'utilisateur est " + text_edit.text + ", je remonte le signal")
				player_entered.emit(text_edit.text)
				
				return # Quitte la fonction après avoir traité l'événement
		
