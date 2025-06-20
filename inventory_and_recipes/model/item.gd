class_name Item
extends Resource

## The name of the item.
@export var name:String

## The icon of the item.
@export var icon:Texture2D

## Shoppe price
@export var price:int = 5


## The desired pixel width for the Sprite2D. Use 0 for original size.
@export var desired_width_px: float = 32.0 # Nouvelle propriété pour la largeur souhaitée
## The desired pixel height for the Sprite2D. Use 0 for original size.
@export var desired_height_px: float = 32.0 # Nouvelle propriété pour la hauteur souhaitée


## Instantiates the 2d representation and initializes it with the 
## current item
func instantiate() -> Sprite2D:
	var result = Sprite2D.new()
	
	result.texture = icon
	
	if icon: # Assurez-vous qu'il y a une texture
		var original_size = icon.get_size()
		
		
		var scale_x = 1.0
		if desired_width_px > 0 and original_size.x > 0:
			scale_x = desired_width_px / original_size.x
		
		var scale_y = 1.0
		if desired_height_px > 0 and original_size.y > 0:
			scale_y = desired_height_px / original_size.y
		
		# Applique l'échelle calculée. Si l'une des dimensions est 0, elle gardera l'échelle 1
		# Si vous voulez garder les proportions, utilisez scale_x pour les deux ou ajustez.
		result.scale = Vector2(scale_x, scale_y)
	
	return result
