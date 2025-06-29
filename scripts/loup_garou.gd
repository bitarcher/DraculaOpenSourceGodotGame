class_name LoupGarou
extends CharacterBody2D

const SPEED = 50.0 # Augmenté un peu pour un mouvement plus visible

@export var initial_direction: int = 1 # 1 pour droite, -1 pour gauche

@export var is_dying: bool = false

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d_howling: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var breathing_audio_stream_player_2d: AudioStreamPlayer2D = $BreathingAudioStreamPlayer2D
@onready var injury_audio_stream_player_2d_2: AudioStreamPlayer2D = %InjuryAudioStreamPlayer2D2
@onready var blood_particles: GPUParticles2D = %BloodParticles
@onready var injury_zone: InjuryZone = %InjuryZone
@onready var being_hit_collision_shape_2d: CollisionShape2D = $BeingHitCollisionShape2D
@onready var damage_receiver_component: DamageReceiverComponent = %DamageReceiverComponent
@onready var pickup_scene: PackedScene = preload("res://inventory_and_recipes/elements/pickup/pickup.tscn")

@export var health:float:
	set(value):
		damage_receiver_component.current_life_counter = value
	get:
		return damage_receiver_component.current_life_counter

enum State {
	WALKING,
	HOWLING,
	INJURED,
	DYING
}

@export var previous_not_injured_state: State = State.WALKING
@export var current_state: State = State.WALKING
@export var current_direction: int = initial_direction

func _stop_all_audios() -> void:
	audio_stream_player_2d_howling.stop()
	breathing_audio_stream_player_2d.stop()
	injury_audio_stream_player_2d_2.stop()

func _process(delta: float) -> void:
	if is_dying:
		return # Stop all normal processing when dying
	
	match current_state:
		State.WALKING:
			_handle_walking(delta)
		State.HOWLING:
			# Rien à faire dans _process pendant le hurlement,
			# le changement d'état sera géré par le signal finished du son.
			pass
		State.INJURED:
			pass

func _physics_process(delta: float) -> void:
	if is_dying:
		velocity.y += get_gravity().y * delta
		velocity.x = 0 # Stop horizontal movement
		move_and_slide()
		return # Important to return to avoid further processing in DYING state
	
	match current_state:
		State.WALKING:
			if not is_on_floor():
				pass
				#velocity.y += get_gravity().y * delta
			move_and_slide()
		_:# Default case for other states
			pass

func _handle_walking(delta: float) -> void:
	var collision_detected = false

	if current_direction == 1: # Va à droite
		velocity.x = SPEED
		if ray_cast_right.is_colliding():
			collision_detected = true
	elif current_direction == -1: # Va à gauche
		velocity.x = -SPEED
		if ray_cast_left.is_colliding():
			collision_detected = true

	# If no collision, continue moving horizontally
	if not collision_detected:
		pass # velocity.x is already set
	else:
		_change_state(State.HOWLING)

func _change_state(new_state: State) -> void:
	if(current_state != State.INJURED and current_state != State.DYING):
		previous_not_injured_state = current_state
	current_state = new_state

	match current_state:
		State.INJURED:
			animated_sprite.stop()
			blood_particles.emitting = true
			injury_audio_stream_player_2d_2.play()		
		State.WALKING:
			animated_sprite.play("walk")
			breathing_audio_stream_player_2d.play()
			_update_sprite_direction()
		State.HOWLING:
			breathing_audio_stream_player_2d.stop()
			animated_sprite.play("howling")
			if audio_stream_player_2d_howling.stream != null:
				audio_stream_player_2d_howling.play()
				if not audio_stream_player_2d_howling.is_connected("finished", _on_audio_finished):
					audio_stream_player_2d_howling.connect("finished", _on_audio_finished)
			else:
				print("LoupGarou: AudioStreamPlayer2D n'a pas de stream assigné pour le hurlement.")
				_on_audio_finished()
		State.DYING:
			# Stop all movement and disable collisions
			set_physics_process(true) # Ensure physics process is active for gravity
			set_process(false) # Stop _process updates
			animated_sprite.stop()
			_stop_all_audios()
			
			get_node("BeingHitCollisionShape2D").set_deferred("disabled", true)
			injury_zone.set_deferred("monitorable", false)
			injury_zone.set_deferred("monitoring", false)
			
			# Rotation and Sagging Tween (purely visual)
			var death_tween = create_tween()
			var target_rotation_degrees = 90.0 * current_direction # 90 degrees to fall on side
			
			# Estimate for sagging (adjust as needed, this is a visual offset)
			var sagging_offset_y = 10.0 # Move down by 10 pixels visually
			
			# Tween rotation of AnimatedSprite2D
			death_tween.tween_property(animated_sprite, "rotation_degrees", target_rotation_degrees, 0.5)
			# Tween position.y of LoupGarou (the Node2D itself) for sagging
			death_tween.tween_property(self, "position:y", position.y + sagging_offset_y, 0.5)
			
			await death_tween.finished

			# Spawn pickup
			var leather_item: Item = load("res://inventory_and_recipes/data/items/leather.tres")
			var pickup_instance: Pickup = pickup_scene.instantiate()
			get_tree().current_scene.add_child(pickup_instance)
			pickup_instance.global_position = global_position
			pickup_instance.item = leather_item

			# Spawn second pickup 50 pixels to the right
			var second_pickup_instance: Pickup = pickup_scene.instantiate()
			get_tree().current_scene.add_child(second_pickup_instance)
			second_pickup_instance.global_position = global_position + Vector2(30, 0)
			second_pickup_instance.item = leather_item

			# Fade out Tween
			var fade_tween = create_tween()
			fade_tween.tween_property(animated_sprite, "modulate:a", 0.0, 3.0)
			await fade_tween.finished
			
			queue_free()

func _on_audio_finished() -> void:
	if audio_stream_player_2d_howling.is_connected("finished", _on_audio_finished):
		audio_stream_player_2d_howling.disconnect("finished", _on_audio_finished)

	# Inverse la direction après le hurlement
	current_direction *= -1
	_change_state(State.WALKING) # Retourne à l'état de marche

func _update_sprite_direction():
	animated_sprite.flip_h = (current_direction == -1)


func _on_damage_receiver_component_killed() -> void:
	injury_zone.queue_free()
	_change_state(State.DYING)

func _on_damage_receiver_component_damage_received(strength: float, new_life_counter: float) -> void:
	_change_state(State.INJURED)

func _on_injury_audio_stream_player_2d_2_finished() -> void:
	_change_state(previous_not_injured_state)
