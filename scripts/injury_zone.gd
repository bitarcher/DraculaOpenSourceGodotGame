class_name InjuryZone
extends Area2D

@export var injury_strength: float = 34 

enum EnumInjuryZoneType {
	BEAST,
	NATURE_ELEMENT,
	BOSS,
	PROJECTILE,
	PHYSICAL, # burried by stones, can't move while jumping
}


@export var injury_zone_type: EnumInjuryZoneType = EnumInjuryZoneType.NATURE_ELEMENT

func _on_body_entered(body: Node2D) -> void:
	print(body.get_class() + " entered injury zone " + self.get_class())
	
	if ToolsSingleton.is_body_relative_to_player(body):
		GameManagerSingleton.injured(injury_zone_type, injury_strength)
