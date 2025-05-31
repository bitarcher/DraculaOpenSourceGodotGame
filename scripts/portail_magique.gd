extends Area2D

var mutex = false

func _on_body_entered(body: Node2D) -> void:
	if(mutex):
		return
	mutex = true
	var players = get_tree().get_nodes_in_group("Player")
	
	for p in players:
		if (p is PlayerPlatformer):
			var playerPlatformer = p as PlayerPlatformer
			playerPlatformer.enter_vortex()
	
	Engine.time_scale = 0.3
	$AudioStreamPlayer.play()
	Engine.time_scale = 1.0
	await $AudioStreamPlayer.finished
	
	for p in players:
		if (p is PlayerPlatformer):
			var playerPlatformer = p as PlayerPlatformer
			playerPlatformer.get_out_from_vortex()
	
	mutex = false
	GameManagerSingleton.next_level()
	
