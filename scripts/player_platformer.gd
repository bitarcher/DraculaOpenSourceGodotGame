class_name PlayerPlatformer
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -350.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var air_rotation_return_speed: float = 5 # Degrees per second, adjust as needed
@export var air_rotation_speed: float = 20 

func _ready() -> void:
	GameManagerSingleton.connect("player_injured", _on_player_injured)
	GameManagerSingleton.connect("player_killed", _on_player_killed)

func _on_player_injured() -> void:
	print("player injured callback")
	$AnimatedSprite2D/InjuredAnimationPlayer.play("injured")
	$InjuryAudioStreamPlayer.play()
	
func _on_player_killed() -> void:
	print("player killed callback")
	#$AnimatedSprite2D/InjuredAnimationPlayer.play("injured")
	$DyingAudioStreamPlayer.play()
	$CollisionShape2D.queue_free()
	
func enter_vortex():
	$AnimatedSprite2D/AnimationPlayer.play("enter_vortex")
	
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
		if(direction != 0):
			animated_sprite_2d.rotate(air_rotation_speed * direction * delta)
		else:
			animated_sprite_2d.rotation = lerp_angle(animated_sprite_2d.rotation, 0.0, air_rotation_return_speed * delta)
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
