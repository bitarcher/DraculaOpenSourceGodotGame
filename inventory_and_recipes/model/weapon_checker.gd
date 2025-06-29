class_name WeaponChecker
extends Resource

var currently_used_items: CurrentlyUsedItems

func _init(currently_used_items: CurrentlyUsedItems) -> void:
	self.currently_used_items = currently_used_items

func get_current_weapon_that_should_be_used_or_empty() -> String:
	if currently_used_items.has_slingshot():
		return CurrentlyUsedItems.SLINGSHOT
		
	return ""

func get_current_weapon_that_should_be_used_or_null(player_platformer: PlayerPlatformer) -> Node2D:
	for child in player_platformer.get_children():
		pass
	
	return null
	
	
func check_weapons(player_platformer: PlayerPlatformer) -> bool:
	# returns true if change has been made
	var result: bool = false
	
	
	return result
