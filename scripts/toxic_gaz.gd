extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var total_frames = 4
	if total_frames > 0:
		var random_start_frame = randi() % total_frames
		animated_sprite.frame = random_start_frame
