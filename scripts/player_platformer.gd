class_name PlayerPlatformer
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -350.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var blood_particles: GPUParticles2D = %BloodParticles

@export var air_rotation_return_speed: float = 5 # Degrees per second, adjust as needed
@export var air_rotation_speed: float = 20 

func _ready() -> void:
	GameManagerSingleton.connect("player_injured", _on_player_injured)
	GameManagerSingleton.connect("health_changed", _on_health_changed)
	GameManagerSingleton.connect("player_killed", _on_player_killed)
	$DamageReceiverComponent.current_life_counter = GameManagerSingleton.health

func _on_health_changed(health: float) -> void:
	$DamageReceiverComponent.current_life_counter = health

func _on_player_injured(strength: float) -> void:
	print("player injured callback")
	$AnimatedSprite2D/InjuredAnimationPlayer.play("injured")
	$InjuryAudioStreamPlayer.play()
	#$DamageReceiverComponent.take_damage(strength)
	blood_particles.emitting = true
	
func _on_player_killed() -> void:
	print("player killed callback")
	#$AnimatedSprite2D/InjuredAnimationPlayer.play("injured")
	$DyingAudioStreamPlayer.play()
	$CollisionShape2D.queue_free()
	#$DamageReceiverComponent.take_damage(100000000000000000)
	
func enter_vortex():
	$AnimatedSprite2D/AnimationPlayer.play("enter_vortex")
	
func _get_global_camera() -> Camera2D:
	var global_cameras = ToolsSingleton.get_nodes_in_group_from_node(get_tree().current_scene, "GlobalCamera")
	
	if(len(global_cameras) > 0):
		return global_cameras[0]
	else:
		return null
		
func _get_player_camera() -> Camera2D:
	var camera = ToolsSingleton.get_node_from_class(self, "Camera2D")
	return camera

func stop_following_player():
	var player_camera: Camera2D = _get_player_camera()
	var global_camera: Camera2D = _get_global_camera()
	
	
	
	if player_camera and player_camera.is_current():
		# 1. Copier la position globale (et la rotation/zoom si nécessaire) de la caméra du joueur
		# vers la caméra globale AVANT de changer de caméra.
		if global_camera:
			global_camera.global_position = player_camera.global_position
			global_camera.zoom = player_camera.zoom # Copie aussi le zoom
			# Si vous utilisez des rotations sur la caméra, copiez aussi global_rotation
			# global_camera.global_rotation = player_camera.global_rotation
			
		# 2. Désactiver la caméra du joueur et son traitement
		player_camera.enabled = false # Godot 4
		player_camera.set_process_mode(Node.PROCESS_MODE_DISABLED) # Si elle avait un script qui déplace/ajuste

		# 3. Activer la caméra globale
		if global_camera:
			global_camera.enabled = true # Godot 4
			global_camera.make_current() # Rend cette caméra la caméra active
			print("La caméra du joueur a été désactivée, la caméra globale est active à la position du joueur.")
		else:
			push_warning("La GlobalCamera n'a pas été trouvée ! Le suivi a été arrêté mais aucune autre caméra n'est active.")
	elif not player_camera:
		push_warning("La PlayerCamera n'est pas configurée ou introuvable.")

	
func get_out_from_vortex():
	animated_sprite_2d.rotation_degrees = 0
	animated_sprite_2d.scale = Vector2(1.0, 1.0)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var is_jumping: bool 

	if Input.is_action_just_pressed("escape"):
		GameManagerSingleton.show_menu()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	else:
		is_jumping = false
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction < 0:
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		animated_sprite_2d.flip_h = false

	if not is_on_floor():
		animated_sprite_2d.play("jump")
		##if(direction != 0):
		#	animated_sprite_2d.rotate(air_rotation_speed * direction * delta)
		#else:
		#	animated_sprite_2d.rotation = lerp_angle(animated_sprite_2d.rotation, 0.0, air_rotation_return_speed * delta)
	else:
		
		animated_sprite_2d.rotation_degrees = 0
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
			
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
