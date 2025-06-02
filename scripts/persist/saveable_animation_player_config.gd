# SaveableAnimationPlayerConfig.gd
class_name SaveableAnimationPlayerConfig
extends Resource

@export var current_animation: String = "" # Full path (library_name/animation_name) of the currently playing animation
@export var current_animation_position: float = 0.0 # Current playback position of the animation
@export var autoplay_on_load: String = "" # Full path of the animation to autoplay when loaded (if any)
@export var speed_scale: float = 1.0 # Playback speed of the animation
@export var assigned_libraries: Dictionary = {} # Dictionary to store AnimationLibrary resources by their name

# This method captures the configuration from an existing AnimationPlayer.
# It doesn't need the animated object as a parameter because it extracts info
# directly from the AnimationPlayer itself.
func capture_from_animation_player(player: AnimationPlayer):
	# Capture basic properties
	current_animation = player.current_animation
	current_animation_position = player.current_animation_position # This is a getter in Godot 4
	autoplay_on_load = player.autoplay
	speed_scale = player.speed_scale

	# Clear existing captured libraries
	assigned_libraries.clear()

	# Iterate through the AnimationPlayer's assigned AnimationLibraries
	# AnimationPlayer (and AnimationMixer) manages libraries, not individual animations directly.
	for library_name in player.get_animation_library_list():
		var animation_library_resource = player.get_animation_library(library_name)
		if animation_library_resource != null:
			# Godot automatically serializes sub-resources.
			# If the AnimationLibrary is an internal resource (embedded in the scene), it will be saved with this config.
			# If it's an external resource (a separate .res/.tres file), its path will be saved,
			# and it will be reloaded via its path when applied.
			assigned_libraries[library_name] = animation_library_resource
		else:
			push_warning("AnimationLibrary '" + library_name + "' is null in AnimationPlayer.")

# This method applies the captured configuration to an existing AnimationPlayer.
# The 'animated_object' is the target node that the AnimationPlayer is supposed to animate.
# It's a parameter, not a serialized property of this resource.
func apply_to_animation_player(player: AnimationPlayer, animated_object: Node):
	# First, remove any existing AnimationLibraries to avoid conflicts.
	# WARNING: This will also remove libraries assigned directly in the editor!
	# It's generally safer to manage libraries programmatically or ensure they are not
	# meant to persist if you're dynamically adding/removing them.
	for library_name in player.get_animation_library_list():
		player.remove_animation_library(library_name)

	# Reassign the AnimationLibraries from the captured config
	for library_name in assigned_libraries:
		var animation_library_resource = assigned_libraries[library_name]
		if animation_library_resource is AnimationLibrary:
			player.add_animation_library(library_name, animation_library_resource)
		else:
			# This handles cases where the resource was external and only its path was saved,
			# but also catches invalid resources.
			push_warning("AnimationLibrary resource for '" + library_name + "' is not a valid AnimationLibrary.")

	player.speed_scale = speed_scale
	player.autoplay = autoplay_on_load # This property still exists in Godot 4

	# Note on animation tracks and node paths:
	# Animation resources (within AnimationLibraries) contain tracks that point to node properties
	# using node paths (e.g., "Model:position"). These paths are relative to the node to which the
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
	# In Godot 4, has_animation() checks for the full path (library_name/animation_name)
	if current_animation != "" and player.has_animation(current_animation):
		player.play(current_animation)
		# Use seek() to set the playback position, as current_animation_position is read-only
		player.seek(current_animation_position, true)
	elif autoplay_on_load != "" and player.has_animation(autoplay_on_load):
		player.play(autoplay_on_load)
