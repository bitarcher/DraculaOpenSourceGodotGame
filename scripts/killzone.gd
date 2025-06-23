extends Area2D

@export var killzone_enabled: bool = true
@export var camera_should_stop_following_player: bool = false

func _on_body_entered(body: Node2D) -> void:
	if(killzone_enabled):
		if ToolsSingleton.is_body_relative_to_player(body):
			GameManagerSingleton.killed()
			
			if(camera_should_stop_following_player):
				var players = ToolsSingleton.get_nodes_in_group_from_node(get_tree().current_scene, "Player")
				if(len(players) > 0):
					var player = players[0] as PlayerPlatformer
					player.stop_following_player()
			
		
