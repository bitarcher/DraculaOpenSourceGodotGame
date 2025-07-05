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
@onready var apothecary_audio_stream_player: AudioStreamPlayer = %ApothecaryAudioStreamPlayer
@onready var blacksmith_audio_stream_player: AudioStreamPlayer = %BlacksmithAudioStreamPlayer
@onready var grocery_audio_stream_player: AudioStreamPlayer = %GroceryAudioStreamPlayer
@onready var background_sprite_2d: Sprite2D = %BackgroundSprite2D
@onready var invitation_label: Label = %InvitationLabel

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

@export var all_characters: Array[Character] = [
	Character.create_character(0, "Andrei", "res://assets/sprites/buildings/shops/backgrounds/apotecary_1.png", AShop.EnumShopType.APOTHECARY),
	Character.create_character(1, "Elena", "res://assets/sprites/buildings/shops/backgrounds/apotecary_2.png", AShop.EnumShopType.APOTHECARY),
	Character.create_character(2, "Andreea", "res://assets/sprites/buildings/shops/backgrounds/apotecary_3.png", AShop.EnumShopType.APOTHECARY),
	Character.create_character(0, "Alexandru", "res://assets/sprites/buildings/shops/backgrounds/blacksmith_1.png", AShop.EnumShopType.BLACKSMITH),
	Character.create_character(1, "Mihai", "res://assets/sprites/buildings/shops/backgrounds/blacksmith_2.png", AShop.EnumShopType.BLACKSMITH),
	Character.create_character(2, "Ion", "res://assets/sprites/buildings/shops/backgrounds/blacksmith_3.png", AShop.EnumShopType.BLACKSMITH),
	Character.create_character(0, "Ioana", "res://assets/sprites/buildings/shops/backgrounds/grocery_1.png", AShop.EnumShopType.GROCERY),
	Character.create_character(1, "Maria", "res://assets/sprites/buildings/shops/backgrounds/grocery_2.png", AShop.EnumShopType.GROCERY),
	Character.create_character(2, "Stefan", "res://assets/sprites/buildings/shops/backgrounds/grocery_3.png", AShop.EnumShopType.GROCERY),
]

var _is_music_set: bool = false

func _set_music() -> void:
	if _is_music_set:
		return
	
	match _shop_type:
		AShop.EnumShopType.BLACKSMITH:
			blacksmith_audio_stream_player.play()
			apothecary_audio_stream_player.stop()
			grocery_audio_stream_player.stop()
		AShop.EnumShopType.GROCERY:
			grocery_audio_stream_player.play()
			apothecary_audio_stream_player.stop()
			blacksmith_audio_stream_player.stop()
		AShop.EnumShopType.APOTHECARY:
			apothecary_audio_stream_player.play()	
			blacksmith_audio_stream_player.stop()
			grocery_audio_stream_player.stop()
			
	_is_music_set = true


func _display_character_portrait(character: Character) -> void:
	if character == null:
		return
			
	invitation_label.text = character.name + ": Hello, how can I help you?"
	
	if not character.background_picture_res_path.is_empty():
		var texture: Texture2D = load(character.background_picture_res_path)
		background_sprite_2d.texture = texture

var _requested_character_portrait_displayed = false

func _display_requested_character_portrait() -> void:
	if _requested_character_portrait_displayed:
		return
	
	if shop == null:
		return
	
	var found_character = null
	
	for c in all_characters:
		if c.num == shop.character_id and shop_type == c.shop_type:
			found_character = c
			break
	
	if found_character != null:
		_display_character_portrait(found_character)
		_requested_character_portrait_displayed = true

func _process(delta: float) -> void:
	match _shop_type:
		AShop.EnumShopType.BLACKSMITH:
			front_of_shop_and_door_node_2d_container.scale.x = -1
			front_of_shop_and_door_node_2d_container.position.x = 1152
		_:
			front_of_shop_and_door_node_2d_container.scale.x = 1
			front_of_shop_and_door_node_2d_container.position.x = 0
	
	_display_requested_character_portrait()		
	_set_music()

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

class Character extends Resource:
	@export var num: int
	@export var name: String
	@export var background_picture_res_path: String
	@export var shop_type: AShop.EnumShopType
	
	static func create_character(num: int, name: String, background_picture_res_path: String, shop_type: AShop.EnumShopType) -> Character :
		var result = Character.new()
		
		result.num = num
		result.name = name
		result.background_picture_res_path = background_picture_res_path
		result.shop_type = shop_type
		
		return result
		
	
