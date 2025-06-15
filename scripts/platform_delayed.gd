class_name PlatformDelayed
extends AnimatableBody2D

@export var consumed: bool = false
@export var wait_time_in_second_once_touched: float = 2.5
@onready var timer_once_touched: Timer = $TimerOnceTouched
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite_2d: Sprite2D = %Sprite2D

static var _next_uid: int = 0

var uid: int

func _init():
	# Assigne un UID unique à cette instance
	uid = _get_next_uid()

func _get_next_uid() -> int:
	_next_uid += 1
	return _next_uid

func _ready():
	timer_once_touched.wait_time = wait_time_in_second_once_touched

# used for restoring state
func go_straight_to_consumed_state() -> void:
	sprite_2d.visible = false
	
	if(animation_player != null):
		animation_player.queue_free()
	
	if ($CollisionShape2D != null):
		$CollisionShape2D.queue_free()
	
	consumed = true
	
func _on_area_2d_body_entered(_body: Node2D) -> void:
	timer_once_touched.start()


func _on_timer_once_touched_timeout() -> void:
	timer_once_touched.stop()
	if(animation_player != null):
		animation_player.play("modulate")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(animation_player != null):
		animation_player.queue_free()
	
	if ($CollisionShape2D != null):
		$CollisionShape2D.queue_free()
	
	consumed = true
	print("end of trap")# Replace with function body.
