extends Node2D
class_name Pickup


@export var item:Item

func _add_item_represention():
	if(item != null):
		var visual_representation = item.instantiate()
		add_child(visual_representation)
		_has_added_item_representation = true

func _ready():
	if(item != null):
		_add_item_represention()
	else:
		print("warning, pickup item is null")
	
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var area_2d: Area2D = %Area2D

var _has_added_item_representation = false

func _process(delta: float) -> void:
	
	if not _has_added_item_representation and item != null:
		_add_item_represention()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("pickup._on_area_2d_body_entered(body: " + body.get_class() + ")")
	
	if body.has_method("on_item_picked_up"):
		body.on_item_picked_up(item)
		
		audio_stream_player.play()
		area_2d.queue_free()
		visible = false


func _on_audio_stream_player_finished() -> void:
	queue_free()
