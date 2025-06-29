class_name LoupGarou
extends Node2D

const SPEED = 50.0 # Augmenté un peu pour un mouvement plus visible

@export var initial_direction: int = 1 # 1 pour droite, -1 pour gauche

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d_howling: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var breathing_audio_stream_player_2d: AudioStreamPlayer2D = $BreathingAudioStreamPlayer2D
@onready var injury_audio_stream_player_2d_2: AudioStreamPlayer2D = %InjuryAudioStreamPlayer2D2
@onready var blood_particles: GPUParticles2D = %BloodParticles
@onready var injury_zone: InjuryZone = %InjuryZone

enum State {
	WALKING,
	HOWLING,
	INJURED
}

@export var previous_not_injured_state: State = State.WALKING
@export var current_state: State = State.WALKING
@export var current_direction: int = initial_direction

func _ready() -> void:
	# Assurez-vous que l'animation de marche est jouée au démarrage
	animated_sprite.play("walk") # Assurez-vous d'avoir une animation nommée "walk"
	_update_sprite_direction()

func _process(delta: float) -> void:
	match current_state:
		State.WALKING:
			_handle_walking(delta)
		State.HOWLING:
			# Rien à faire dans _process pendant le hurlement,
			# le changement d'état sera géré par le signal finished du son.
			pass
		State.INJURED:
			pass

func _handle_walking(delta: float) -> void:
	var collision_detected = false

	if current_direction == 1: # Va à droite
		if ray_cast_right.is_colliding():
			collision_detected = true
	elif current_direction == -1: # Va à gauche
		if ray_cast_left.is_colliding():
			collision_detected = true

	if collision_detected:
		_change_state(State.HOWLING)
	else:
		position.x += delta * SPEED * current_direction

func _change_state(new_state: State) -> void:
	if(current_state != State.INJURED):
		previous_not_injured_state = current_state
	current_state = new_state

	match current_state:
		State.INJURED:
			animated_sprite.stop()
			blood_particles.emitting = true
			injury_audio_stream_player_2d_2.play()		
		State.WALKING:
			# ICI LE CHANGEMENT : On relance l'animation de marche
			animated_sprite.play("walk")
			breathing_audio_stream_player_2d.play()
			_update_sprite_direction()
		State.HOWLING:
			breathing_audio_stream_player_2d.stop()
			animated_sprite.play("howling") # Arrête l'animation de marche
			# Optionnel: Changer l'animation pour un hurlement si vous en avez une
			# animated_sprite.play("howl")

			if audio_stream_player_2d_howling.stream != null:
				audio_stream_player_2d_howling.play()
				if not audio_stream_player_2d_howling.is_connected("finished", _on_audio_finished):
					audio_stream_player_2d_howling.connect("finished", _on_audio_finished)
			else:
				print("LoupGarou: AudioStreamPlayer2D n'a pas de stream assigné pour le hurlement.")
				_on_audio_finished()

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


func _on_damage_receiver_component_damage_received(strength: float, new_life_counter: float) -> void:
	_change_state(State.INJURED)

func _on_injury_audio_stream_player_2d_2_finished() -> void:
	_change_state(previous_not_injured_state)
