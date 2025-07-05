extends Node2D
class_name InsideShop

var _shop: AShop
@onready var front_of_shop_and_door_node_2d_container: Node2D = %FrontOfShopAndDoorNode2DContainer
@onready var nine_patch_rect: NinePatchRect = %NinePatchRect

signal inside_shop_exited(emiter: InsideShop)
@onready var background_animation_player: AnimationPlayer = %BackgroundAnimationPlayer
@onready var front_of_shop_animation_player: AnimationPlayer = %FrontOfShopAnimationPlayer
@onready var door_animation_player: AnimationPlayer = %DoorAnimationPlayer
@onready var door_audio_stream_player: AudioStreamPlayer = %DoorAudioStreamPlayer

var _shop_type: AShop.EnumShopType = AShop.EnumShopType.GROCERY

@export var shop_type: AShop.EnumShopType:
	set(value):
		_shop_type = value
	get():
		return _shop_type

@export var shop: AShop:
	set(value):
		_shop = value
		shop_type = value.shop_type
		
	get():
		return _shop

func _process(delta: float) -> void:
	match _shop_type:
		AShop.EnumShopType.BLACKSMITH:
			front_of_shop_and_door_node_2d_container.scale.x = -1
			front_of_shop_and_door_node_2d_container.position.x = 1152
		_:
			front_of_shop_and_door_node_2d_container.scale.x = 1
			front_of_shop_and_door_node_2d_container.position.x = 0

func show_menu():
	nine_patch_rect.visible = true

func hide_menu():
	nine_patch_rect.visible = false


func _on_exit_button_pressed() -> void:
	door_audio_stream_player.play()
	background_animation_player.play_backwards("zoom")
	front_of_shop_animation_player.play_backwards("zoom")
	door_animation_player.play_backwards("open_door")
	await background_animation_player.animation_finished
	inside_shop_exited.emit(self)
