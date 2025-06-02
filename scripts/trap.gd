class_name Trap
extends AnimatableBody2D

@export var consumed: bool = false

func end_of_trap():
	if($AnimationPlayer != null):
		$AnimationPlayer.queue_free()
	
	if ($CollisionShape2D != null):
		$CollisionShape2D.queue_free()
	
	consumed = true
	print("end of trap")

# used for restoring state
func go_straight_to_consumed_state() -> void:
	var animation_player = $AnimationPlayer
	animation_player.play("launch_trap")
	var animation_length = animation_player.get_animation("launch_trap").length
	animation_player.seek(animation_length, true)
	#animation_player.stop()
	
func _on_area_2d_body_entered(_body: Node2D) -> void:
	if($AnimationPlayer != null):
		$AnimationPlayer.play("launch_trap")
