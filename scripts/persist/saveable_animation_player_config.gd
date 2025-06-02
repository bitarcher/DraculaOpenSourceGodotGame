# SaveableAnimationPlayerConfig.gd
extends Resource
class_name SaveableAnimationPlayerConfig

@export var current_animation: String = "" # Name of the currently playing animation
@export var playback_position: float = 0.0 # Current playback position of the animation
@export var autoplay_on_load: String = "" # Name of the animation to autoplay when loaded (if any)
@export var speed_scale: float = 1.0 # Playback speed of the animation
@export var assigned_animations: Dictionary = {} # Dictionary to store animation resources by their name

# This method captures the configuration from an existing AnimationPlayer.
# It doesn't need the animated object as a parameter because it extracts info
# directly from the AnimationPlayer itself.
func capture_from_animation_player(player: AnimationPlayer):
	current_animation = player.current_animation
	playback_position = player.playback_position
	autoplay_on_load = player.autoplay
	speed_scale = player.speed_scale

	assigned_animations.clear()
	for anim_name in player.get_animation_list():
		var animation_resource = player.get_animation(anim_name)
		if animation_resource != null:
			# Godot automatically serializes sub-resources.
			# If the animation is an internal resource (embedded in the scene), it will be saved with this config.
			# If it's an external resource (a separate .res/.tres file), its path will be saved,
			# and it will be reloaded via its path when applied.
			assigned_animations[anim_name] = animation_resource
		else:
			push_warning("Animation '" + anim_name + "' is null in AnimationPlayer.")

# This method applies the captured configuration to an existing AnimationPlayer.
# The 'animated_object' is the target node that the AnimationPlayer is supposed to animate.
# It's a parameter, not a serialized property of this resource.
func apply_to_animation_player(player: AnimationPlayer, animated_object: Node):
	# First, remove any existing animations to avoid conflicts.
	# WARNING: This will also remove animations assigned directly in the editor!
	for anim_name in player.get_animation_list():
		player.remove_animation(anim_name)

	# Reassign the animations from the captured config
	for anim_name in assigned_animations:
		var animation_resource = assigned_animations[anim_name]
		if animation_resource is Animation:
			player.add_animation(anim_name, animation_resource)
		else:
			# This handles cases where the resource was external and only its path was saved,
			# but also catches invalid resources.
			push_warning("Animation resource for '" + anim_name + "' is not a valid Animation.")

	player.speed_scale = speed_scale
	player.autoplay = autoplay_on_load

	# Note on animation tracks and node paths:
	# Animation resources contain tracks that point to node properties using node paths
	# (e.g., "Model:position"). These paths are relative to the node to which the
	# AnimationPlayer is attached.
	#
	# For animations to work correctly after applying this config, the relative hierarchy
	# between the 'player' (the AnimationPlayer) and the 'animated_object'
	# must remain consistent with how the animations were originally created.
	#
	# If the 'animated_object' is, for example, a direct child of the AnimationPlayer named "Model",
	# then the animation tracks would typically be "Model:position". Godot handles these
	# paths at runtime. As long as the relative path from the AnimationPlayer to the
	# animated node is the same, the animations should apply correctly.

	# Attempt to play the 'current_animation' or 'autoplay_on_load' animation
	if current_animation != "" and player.has_animation(current_animation):
		player.play(current_animation)
		player.seek(playback_position, true)
	elif autoplay_on_load != "" and player.has_animation(autoplay_on_load):
		player.play(autoplay_on_load)
