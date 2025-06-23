class_name Bat
extends Node2D

const SPEED = 25.0

@export var go_left_once_awaken: bool = true
@export var awake: bool = false

var _direction_vector:Vector2 = Vector2.ONE

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_right_bottom: RayCast2D = %RayCastRightBottom
@onready var ray_cast_left_bottom: RayCast2D = %RayCastLeftBottom
@onready var ray_cast_left_top: RayCast2D = %RayCastLeftTop
@onready var ray_cast_rigth_top: RayCast2D = %RayCastRigthTop

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
	position.x += delta * SPEED * normalized_vector.x
	position.y += delta * SPEED * normalized_vector.y
	


func _on_detection_zone_body_entered(body: Node2D) -> void:
	print("bat has detected intruder")
	awake = true
