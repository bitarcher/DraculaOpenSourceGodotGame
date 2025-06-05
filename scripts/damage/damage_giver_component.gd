class_name DamageGiverComponent
extends Node2D

@export var collision_shape_node_path: NodePath
var _cached_collision_shape: CollisionShape2D # A variable to store the found CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Attempt to get the node at the specified NodePath
	var node = get_node_or_null(collision_shape_node_path)
	if node:
		# Check if the found node is a CollisionShape2D
		if node is CollisionShape2D:
			_cached_collision_shape = node
			
			print("Successfully found CollisionShape2D: ", _cached_collision_shape.name)
			# You can now do things with _cached_collision_shape, e.g.:
			# _cached_collision_shape.disabled = true
		else:
			# Handle cases where the path points to a non-CollisionShape2D node
			push_warning("Node at path '%s' is not a CollisionShape2D. Found type: %s" % [collision_shape_node_path, node.get_class()])
			_cached_collision_shape = null # Ensure it's null if the wrong type
	else:
		# Handle cases where no node was found at the given path
		push_warning("No node found at path: %s" % collision_shape_node_path)
		_cached_collision_shape = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# You can now use _cached_collision_shape in _process or other functions
	# For example:
	# if _cached_collision_shape and not _cached_collision_shape.disabled:
	#     print("Collision shape is active!")
	pass
