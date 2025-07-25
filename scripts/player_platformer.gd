class_name PlayerPlatformer
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -350.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var blood_particles: GPUParticles2D = %BloodParticles
@onready var player_collision_shape: CollisionShape2D = $CollisionShape2D # Ajout de la référence au CollisionShape2D du joueur

@export var air_rotation_return_speed: float = 5 # Degrees per second, adjust as needed
@export var air_rotation_speed: float = 20 
@onready var damage_receiver_component: DamageReceiverComponent = $DamageReceiverComponent

signal direction_changed(emiter: PlayerPlatformer, old_direction: int, new_direction: int)

@export var inventory: Inventory:
	get:
		return GameManagerSingleton.inventory

# Calque de collision des pierres (à ajuster si différent)
@export var stone_layer: int = 3

var _jump_positions: Array[Vector2] = []
var _jump_position_timer: float = 0.0

enum EnumPlayerCharacter {
	DEFAULT,
	DIVINE_ARMOR,
	CAMOUFLAGE
}

const NUM_OF_TICKS_DELAY_IN_MSEC_FOR_THE_PLAYER_TO_UNBURY_HIMSELF = 10000

signal unbury_timer_started(start_ticks_in_msec: int, end_ticks_in_msec: int)
signal unbury_timer_progress(current_ticks_in_msec: int)
signal unbury_timer_stopped()

var _unbury_timer_active: bool = false
var _unbury_start_time: int = 0
var _unbury_end_time: int = 0

@export var current_player_character: EnumPlayerCharacter = EnumPlayerCharacter.DEFAULT 

func get_jump_animation() -> String:
	match current_player_character:
		EnumPlayerCharacter.DIVINE_ARMOR:
			return "jump_divine"
		EnumPlayerCharacter.CAMOUFLAGE:
			return "jump_duck"
		_:	
			return "jump"

func get_run_animation() -> String:
	match current_player_character:
		EnumPlayerCharacter.DIVINE_ARMOR:
			return "run_divine_armor"
		EnumPlayerCharacter.CAMOUFLAGE:
			return "run_duck"
		_:	
			return "run"

func get_idle_animation() -> String:
	match current_player_character:
		EnumPlayerCharacter.DIVINE_ARMOR:
			return "idle_divine"
		EnumPlayerCharacter.CAMOUFLAGE:
			return "idle_duck"
		_:	
			return "idle"

			
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
	
	var collision_shape = $CollisionShape2D
	
	if is_instance_valid(collision_shape):
		collision_shape.queue_free()
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
	
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

func _fade_out_animated_player():
	# Vérifie si le nœud AnimatedSprite2D est valide
	if not animated_sprite:
		push_error("AnimatedSprite2D n'est pas trouvé ou configuré.")
		return

	# Crée un nouveau Tween pour l'animation
	var tween = create_tween()
	
	# S'assure que le Tween n'est pas tué prématurément si un autre tween est créé sur le même objet.
	# Le mode default "Tween.TWEEN_MODE_RESTART" est souvent bon pour cela.
	# Si vous voulez s'assurer qu'aucun autre tween ne perturbe celui-ci, utilisez TWEEN_MODE_EXCLUSIVE
	# tween.set_tween_mode(Tween.TWEEN_MODE_EXCLUSIVE) 

	# Configure la propriété à animer :
	# Object: animated_sprite
	# Property: "modulate:a" (le canal alpha de la couleur modulate)
	# Target Value: 0.0 (totalement transparent)
	# Duration: 0.3 (secondes, soit 300 ms)
	tween.tween_property(animated_sprite, "modulate:a", 0.0, 0.1)
	tween.tween_property(damage_receiver_component, "modulate:a", 0.0, 0.1)
	
	# Optionnel: Définir la courbe d'animation (Ease)
	# tween.set_ease(Tween.EASE_OUT)
	# tween.set_trans(Tween.TRANS_QUAD)

	# Optionnel: Attendre la fin du tween
	# await tween.finished
	# print("Le fondu de l'AnimatedSprite2D est terminé.")
	# Vous pouvez détruire le nœud ici, par exemple:
	# animated_sprite.queue_free()

func on_item_picked_up(item: Item):
	print(item.name + " picked up")
	inventory.add_item(item)

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
			global_camera.global_rotation = player_camera.global_rotation
			global_camera.offset = player_camera.offset
			
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
	_fade_out_animated_player()
	
func get_out_from_vortex():
	animated_sprite_2d.rotation_degrees = 0
	animated_sprite_2d.scale = Vector2(1.0, 1.0)
	
var is_rejumping: bool = false

func _process(delta: float) -> void:
	GameManagerSingleton.currently_used_items.weapon_checker.sync_weapons(self)
	
	if GameManagerSingleton.currently_used_items.has_camouflage():
		current_player_character = EnumPlayerCharacter.CAMOUFLAGE
	elif GameManagerSingleton.currently_used_items.has_divine_armor():
		current_player_character = EnumPlayerCharacter.DIVINE_ARMOR
	else:
		current_player_character = EnumPlayerCharacter.DEFAULT

var _previous_direction: int = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		_jump_position_timer += delta
		if _jump_position_timer >= 1.0:
			_jump_positions.append(global_position)
			if _jump_positions.size() > 4:
				_jump_positions.remove_at(0)
			_jump_position_timer = 0.0
	else:
		_jump_positions.clear()
		_jump_position_timer = 0.0

	if Input.is_action_just_pressed("escape"):
		GameManagerSingleton.show_menu()

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			is_rejumping = false
		elif not is_rejumping:
			if GameManagerSingleton.currently_used_items.can_rejump():
				is_rejumping = true
				velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if(direction != _previous_direction):
		direction_changed.emit(self, _previous_direction, direction)
	_previous_direction = direction
	
	if direction < 0:
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		animated_sprite_2d.flip_h = false

	if not is_on_floor():
		animated_sprite_2d.play(get_jump_animation())
		##if(direction != 0):
		#	animated_sprite_2d.rotate(air_rotation_speed * direction * delta)
		#else:
		#	animated_sprite_2d.rotation = lerp_angle(animated_sprite_2d.rotation, 0.0, air_rotation_return_speed * delta)
	else:
		
		animated_sprite_2d.rotation_degrees = 0
		if direction == 0:
			animated_sprite_2d.play(get_idle_animation())
		else:
			animated_sprite_2d.play(get_run_animation())
			
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Vérification pour éviter l'erreur si la forme de collision a été supprimée
	if not is_instance_valid(player_collision_shape) or player_collision_shape.shape == null:
		return

	
	# Détection d'ensevelissement
	if is_buried_under_stones():
		if not _unbury_timer_active:
			_unbury_timer_active = true
			_unbury_start_time = Time.get_ticks_msec()
			_unbury_end_time = _unbury_start_time + NUM_OF_TICKS_DELAY_IN_MSEC_FOR_THE_PLAYER_TO_UNBURY_HIMSELF
			unbury_timer_started.emit(_unbury_start_time, _unbury_end_time)
		else:
			var current_time = Time.get_ticks_msec()
			unbury_timer_progress.emit(current_time)
			if current_time >= _unbury_end_time:
				_unbury_timer_active = false
				unbury_timer_stopped.emit()
				GameManagerSingleton.injured(InjuryZone.EnumInjuryZoneType.PHYSICAL, 100000000000000000) # High strength to ensure death
				
	else:
		if _unbury_timer_active:
			_unbury_timer_active = false
			unbury_timer_stopped.emit()

func is_buried_under_stones() -> bool:
	if _jump_positions.size() < 3:
		return false

	var area: float = 0.0
	var n: int = _jump_positions.size()

	for i in range(n):
		var p1: Vector2 = _jump_positions[i]
		var p2: Vector2 = _jump_positions[(i + 1) % n] # Wrap around to the first point for the last segment
		area += (p1.x * p2.y) - (p1.y * p2.x)

	var real_area = abs(area) / 2.0
	
	return real_area < 300
