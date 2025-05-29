extends AnimatableBody2D

func end_of_trap():
	if($AnimationPlayer != null):
		$AnimationPlayer.queue_free()
	
	if ($CollisionShape2D != null):
		$CollisionShape2D.queue_free()
	print("end of trap")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if($AnimationPlayer != null):
		$AnimationPlayer.play("launch_trap")
