class_name SlimeEnemy
extends CharacterBody2D

const SPEED = 10.0

@export var direction:int  = 1
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var blood_particles: GPUParticles2D = %BloodParticles
@onready var injury_audio_stream_player_2d: AudioStreamPlayer2D = %InjuryAudioStreamPlayer2D
@onready var killed_audio_stream_player_2d: AudioStreamPlayer2D = %KilledAudioStreamPlayer2D
@onready var injury_zone: InjuryZone = %InjuryZone
@onready var damage_receiver_component: DamageReceiverComponent = %DamageReceiverComponent

@export var health:float:
	set(value):
		damage_receiver_component.current_life_counter = value
	get:
		return damage_receiver_component.current_life_counter

@export var killed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(ray_cast_right.is_colliding()):
		direction = -1
		animated_sprite.flip_h = true
		
	if(ray_cast_left.is_colliding()):
		direction = 1
		animated_sprite.flip_h = false
	
	if not killed:
		position.x += delta * SPEED * direction
	


func _on_damage_receiver_component_damage_received(strength: float, new_life_counter: float) -> void:
	blood_particles.emitting = true
	injury_audio_stream_player_2d.play()


func _on_damage_receiver_component_killed() -> void:
	injury_zone.queue_free()
	killed = true
	animated_sprite.play("dying")
	killed_audio_stream_player_2d.play()
	await animated_sprite.animation_finished

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 3.0)
	await tween.finished

	self.queue_free()
