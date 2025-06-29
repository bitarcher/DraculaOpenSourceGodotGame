class_name CurrentlyUsedItems
extends Resource

signal cu_items_changed()

const WINGED_BOOTS: String = "Winged boots"
const CAMOUFLAGE: String = "Camouflage"
const DIVINE_ARMOR: String = "Divine armor"
const HEALTH_POTION: String = "Health potion"
const SLINGSHOT: String = "Slingshot"

@export var cu_items: Array[CurrentlyUsedItem]

@export var weapon_checker: WeaponChecker

func _init() -> void:
	weapon_checker = WeaponChecker.new(self)

func add_cu_item(cu_item: CurrentlyUsedItem):
	cu_items.append(cu_item)
	cu_item.consumed.connect(_consumed)
	cu_items_changed.emit()
	
func get_cu_items() -> Array[CurrentlyUsedItem]:
	return cu_items
	
func add_item(item: Item):
	var cu_item = CurrentlyUsedItem.new_from_item(item)
	
	add_cu_item(cu_item)
	
	if item.name == HEALTH_POTION:
		GameManagerSingleton.set_health(100.0)
	
func _consumed(cu_item: CurrentlyUsedItem):
	cu_items.erase(cu_item)
	cu_items_changed.emit()
	

func clear():
	cu_items.clear()
	cu_items_changed.emit()

func check_and_consumed_currently_used_items():
	var to_remove: Array[CurrentlyUsedItem] = []
	var current_ticks = Time.get_ticks_msec()
	
	for cu_item in cu_items:
		if(cu_item.planned_end_ticks < current_ticks):
			to_remove.append(cu_item)
	
	var found: bool = false		
	for cu_item in to_remove:
		cu_items.erase(cu_item)
		found=true
		
	if found:
		cu_items_changed.emit()


func can_rejump() -> bool:
	var result = false
	
	for cu_item in cu_items:
		if cu_item.item.name == WINGED_BOOTS:
			result = true
	
	return result
	
func has_divine_armor() -> bool:
	var result = false
	
	for cu_item in cu_items:
		if cu_item.item.name == DIVINE_ARMOR:
			result = true
	
	return result
	
func has_slingshot() -> bool:
	var result = false
	
	for cu_item in cu_items:
		if cu_item.item.name == SLINGSHOT:
			result = true
	
	return result
	

	
func has_camouflage() -> bool:
	var result = false
	
	for cu_item in cu_items:
		if cu_item.item.name == CAMOUFLAGE:
			result = true
	
	return result
	
func has_health_potion() -> bool:
	var result = false
	
	for cu_item in cu_items:
		if cu_item.item.name == HEALTH_POTION:
			result = true
	
	return result
	
func get_defense_factor(injury_zone_type: InjuryZone.EnumInjuryZoneType) -> float:
	var camouflage : bool = has_camouflage()
	var divine_armor : bool = has_divine_armor()
	var health_potion : bool = has_health_potion()
	
	var result = 1.0
	
	if health_potion:
		result *= 3.0
	
	if camouflage:
		if  injury_zone_type == InjuryZone.EnumInjuryZoneType.BEAST:
			result *= 100000.0
			
	if divine_armor:
		result  *= 3
	
	return result
