class_name Bat
extends CharacterBody2D

const SPEED = 25.0

@export var go_left_once_awaken: bool = true
@export var awake: bool = false

var _direction_vector:Vector2 = Vector2.ONE
var is_dying: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_right_bottom: RayCast2D = %RayCastRightBottom
@onready var ray_cast_left_bottom: RayCast2D = %RayCastLeftBottom
@onready var ray_cast_left_top: RayCast2D = %RayCastLeftTop
@onready var ray_cast_rigth_top: RayCast2D = %RayCastRigthTop
@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var injury_zone: InjuryZone = %InjuryZone
@onready var blood_particles: GPUParticles2D = %BloodParticles
@onready var ray_cast_down: RayCast2D = %RayCastDown
@onready var being_hit_collision_shape_2d: CollisionShape2D = $BeingHitCollisionShape2D
@onready var detection_zone: Area2D = $DetectionZone
@onready var damage_receiver_component: DamageReceiverComponent = %DamageReceiverComponent

@export var health:float:
	set(value):
		damage_receiver_component.current_life_counter = value
	get:
		return damage_receiver_component.current_life_counter

func _ready() -> void:
	if go_left_once_awaken:
		_direction_vector.x = -1
		_direction_vector.y = 1
	else:
		_direction_vector.x = 1
		_direction_vector.y = 1

func _keep_direction() -> bool:
	var r = (randi() % 4) != 0
	
	return r

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not awake:
		return
		
	if not audio_stream_player_2d.playing and not is_dying:
		audio_stream_player_2d.play()
	
	if not is_dying:	
		animated_sprite.play("move")
	
	var keep_direction = _keep_direction()
	
	if(ray_cast_right_bottom.is_colliding()):
		_direction_vector.x = 1 if keep_direction else -1
		_direction_vector.y = -1
		
	if(ray_cast_rigth_top.is_colliding()):
		_direction_vector.x = 1 if keep_direction else -1
		_direction_vector.y = 1
		
	if(ray_cast_left_bottom.is_colliding()):
		_direction_vector.x = -1 if keep_direction else 1
		_direction_vector.y = -1
		
	if(ray_cast_left_top.is_colliding()):
		_direction_vector.x = -1 if keep_direction else 1
		_direction_vector.y = 1
		
	var normalized_vector = _direction_vector.normalized()
	velocity.x = SPEED * normalized_vector.x
	velocity.y = SPEED * normalized_vector.y
	
	move_and_slide()
	
func _physics_process(delta: float) -> void:
	if is_dying:
		velocity.y += get_gravity().y * delta
		move_and_slide()
		
		ray_cast_down.force_raycast_update()
		if ray_cast_down.is_colliding():
			animated_sprite.stop()
			ray_cast_down.enabled = false
			var collided_body = ray_cast_down.get_collider()
			var global_pos_before_reparent = global_position
			
			# Detach from current parent
			get_parent().remove_child(self)
			
			# Attach to new parent
			collided_body.add_child(self)
			
			# Maintain global position
			global_position = global_pos_before_reparent
			
			# Stop all further movement and start fade out
			set_physics_process(false) # Stop _physics_process updates
			set_process(false) # Stop _process updates
			
			var tween = create_tween()
			tween.tween_property(animated_sprite, "modulate:a", 0.0, 4.0)
			await tween.finished
			
			queue_free()
		return

func _on_detection_zone_body_entered(body: Node2D) -> void:
	print("bat has detected intruder")
	awake = true

func _on_damage_receiver_component_damage_received(strength: float, new_life_counter: float) -> void:
	awake = true
	blood_particles.emitting = true

func _on_damage_receiver_component_killed() -> void:
	is_dying = true
	injury_zone.queue_free()
	animated_sprite.play("dying")
	
	# Assuming you have a 'dying' animation or want to set a specific frame
	# animated_sprite.animation = "dying" # if you have one
	# animated_sprite.frame = 0 # or a specific frame
	
	being_hit_collision_shape_2d.set_deferred("disabled", true)
	detection_zone.set_deferred("monitorable", false)
	detection_zone.set_deferred("monitoring", false)
	audio_stream_player_2d.stop()
	ray_cast_right_bottom.enabled = false
	ray_cast_left_bottom.enabled = false
	ray_cast_left_top.enabled = false
	ray_cast_rigth_top.enabled = false
	ray_cast_down.enabled = true


	# The rest of the logic (gravity, reparenting, fade) is now in _physics_process
	# and will be handled once ray_cast_down collides.
	
func _on_bat_serializable_component_loaded(bat_saved_data: BatSavedData) -> void:
	awake = bat_saved_data.awake
	position = bat_saved_data.position
	_direction_vector = bat_saved_data.direction_vector
	
func _on_bat_serializable_component_about_to_be_saved() -> BatSavedData:
	var bat_saved_data = BatSavedData.new()
	bat_saved_data.awake = awake
	bat_saved_data.position = position
	bat_saved_data.direction_vector = _direction_vector
	return bat_saved_data
