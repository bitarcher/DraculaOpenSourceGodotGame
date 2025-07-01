class_name AShop
extends StaticBody2D

@onready var question_label: Label = %QuestionLabel

enum EnumShopType {
	GROCERY,
	BLACKSMITH,
	APOTHECARY
}

@onready var door_polygon_2d: Polygon2D = %DoorPolygon2D
@onready var nine_patch_rect: NinePatchRect = %NinePatchRect

@export var shop_type: EnumShopType = EnumShopType.GROCERY
var _is_player_plaformer_inside: bool = false

func _set_question_label() -> void:
	match shop_type:
		EnumShopType.GROCERY:
			question_label.text = "Enter grocery ?"
		EnumShopType.BLACKSMITH:
			question_label.text = "Enter blacksmith ?"
		EnumShopType.APOTHECARY:
			question_label.text = "Enter apothecary ?"
		_:
			question_label.text = "Enter estanlishment ?"
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_question_label()

var _next_door_polygon_visibility_toogle_ticks_msec = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _is_player_plaformer_inside:
		var now = Time.get_ticks_msec()
		if now > _next_door_polygon_visibility_toogle_ticks_msec:
			door_polygon_2d.visible = not door_polygon_2d.visible
			_next_door_polygon_visibility_toogle_ticks_msec = now + 300


func _on_near_area_2d_body_entered(body: Node2D) -> void:
	if(body is PlayerPlatformer):
		_is_player_plaformer_inside = true
		_set_question_label()

func _on_near_area_2d_body_exited(body: Node2D) -> void:
	if(body is PlayerPlatformer):
		_is_player_plaformer_inside=false
		door_polygon_2d.visible = false

func _on_yes_button_pressed() -> void:
	pass
	
func _on_in_front_of_t_the_door_area_2d_body_entered(body: Node2D) -> void:
	if (body is PlayerPlatformer):
		nine_patch_rect.visible = true


func _on_in_front_of_t_the_door_area_2d_body_exited(body: Node2D) -> void:
	if (body is PlayerPlatformer):
		nine_patch_rect.visible = false
