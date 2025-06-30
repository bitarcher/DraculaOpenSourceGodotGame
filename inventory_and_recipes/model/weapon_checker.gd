class_name WeaponChecker
extends Resource

var currently_used_items: CurrentlyUsedItems

func _init(currently_used_items: CurrentlyUsedItems) -> void:
	self.currently_used_items = currently_used_items

func get_current_weapon_that_should_be_used_or_empty() -> String:
	if currently_used_items.has_bow():
		return CurrentlyUsedItems.BOW
	
	if currently_used_items.has_slingshot():
		return CurrentlyUsedItems.SLINGSHOT
		
	return ""

func get_current_weapon_that_is_used_or_null(player_platformer: PlayerPlatformer) -> AWeapon:
	for child in player_platformer.get_children():
		if child.is_in_group("Weapon"):
			return child
	
	return null
	
func _remove_weapon(player_platformer: PlayerPlatformer, current_weapon_node: AWeapon):
	if current_weapon_node != null:
		player_platformer.remove_child(current_weapon_node)
		current_weapon_node.queue_free()

func _add_weapon(player_platformer: PlayerPlatformer, weapon_type_that_should_be_used) -> void:
	var packed_scene: PackedScene = null
	
	match weapon_type_that_should_be_used:
		CurrentlyUsedItems.BOW:
			packed_scene = load("res://scenes/weapons/projectile_weapon/bow_weapon.tscn")
		CurrentlyUsedItems.SLINGSHOT:
			packed_scene = load("res://scenes/weapons/projectile_weapon/slingshot_weapon.tscn")
		_:
			push_error(weapon_type_that_should_be_used + " not supported in WeaponChecker yet")
			return
			
	if packed_scene == null:
		push_error("No packed_scene for " + weapon_type_that_should_be_used)
		return
	
	var instanciated: AWeapon = packed_scene.instantiate()
	player_platformer.add_child(instanciated) 
	
func sync_weapons(player_platformer: PlayerPlatformer) -> bool:
	# returns true if change has been made
	var result: bool = false
	var current_weapon_node: AWeapon = get_current_weapon_that_is_used_or_null(player_platformer)
	var current_weapon_node_type_or_empty: String = "" if (current_weapon_node == null) else current_weapon_node.get_weapon_name()
	var weapon_type_that_should_be_used = get_current_weapon_that_should_be_used_or_empty()
		
	if weapon_type_that_should_be_used != current_weapon_node_type_or_empty:
		_remove_weapon(player_platformer, current_weapon_node)
		result = true
		
	if result and weapon_type_that_should_be_used != "":
		_add_weapon(player_platformer, weapon_type_that_should_be_used)	
	
	return result
