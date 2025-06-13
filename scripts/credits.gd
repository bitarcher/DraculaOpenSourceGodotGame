class_name Credits
extends Node2D

@onready var code_edit: CodeEdit = %CodeEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Remplacez "res://chemin/vers/mon_fichier.md" par le chemin réel de votre fichier Markdown
	var chemin_du_fichier_md = "res://credits.md"
	
	# Vérifie si le fichier existe avant d'essayer de le charger
	if not FileAccess.file_exists(chemin_du_fichier_md):
		print("Erreur : Le fichier Markdown n'existe pas à l'emplacement : ", chemin_du_fichier_md)
		return
	
	var fichier_md = FileAccess.open(chemin_du_fichier_md, FileAccess.READ)
	
	if fichier_md:
		# Lit tout le contenu du fichier
		var contenu_markdown = fichier_md.get_as_text()
		
		# Ferme le fichier (important !)
		fichier_md.close()
		
		# Assigne le contenu lu au TextEdit
		code_edit.text = contenu_markdown
		print("Fichier Markdown chargé avec succès dans le CodeEdit.")
		
		# --- Optionnel : Activer la coloration syntaxique Markdown (si disponible) ---
		# Le CodeEdit supporte des highlight_modes. Pour le Markdown, vous pourriez avoir
		# besoin d'un script de coloration personnalisé si Godot ne le fournit pas par défaut.
		# Godot 4 a un support de base pour certains modes. Pour Markdown, ce n'est pas intégré par défaut.
		# Vous devriez charger un fichier de thème de coloration si vous en avez un.
		# Exemple (si vous avez un thème de coloration MD) :
		# self.syntax_highlighter = preload("res://chemin/vers/votre_syntax_highlighter_markdown.gd")
		
	else:
		print("Erreur : Impossible d'ouvrir le fichier Markdown : ", chemin_du_fichier_md)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("escape") and visible:
		GameManagerSingleton.show_menu(false)
