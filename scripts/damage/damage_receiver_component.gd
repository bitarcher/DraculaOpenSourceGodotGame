class_name DamageReceiverComponent
extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar
# IMPORTANT: Adjust this path if your Label is directly under Node2D,
# otherwise, it should be a child of ProgressBar.
@onready var life_value_label: Label = $Label # Assuming Label is a child of ProgressBar

@export var wait_having_some_damage_before_displaying_label_and_progressbar: bool = true

signal killed()
signal damage_received(strength: float, new_life_counter: float)

# Internal backing field for initial_life_counter
var _initial_life_counter : float

@export var initial_life_counter : float = 100.0: # Use 100.0 for float literal clarity
	set(value):
		if(value < 1):
			value = 100.0
		
		# Ensure initial_life_counter is not negative
		_initial_life_counter = max(0.0, value)
		# Update progress_bar.max_value only if the progress_bar node is ready
		if is_node_ready() and progress_bar:
			progress_bar.max_value = _initial_life_counter
		# If you want current_life_counter to automatically re-clamp if max_value decreases,
		# you can re-assign it here, which will trigger its setter:
		# self.current_life_counter = _current_life_counter
	get:
		return _initial_life_counter

# Internal backing field for current_life_counter
var _current_life_counter : float

@export var current_life_counter : float: # RE-ADDED GETTER AND SETTER
	set(value):
		if wait_having_some_damage_before_displaying_label_and_progressbar:
			if life_value_label != null:
				life_value_label.visible = true
			if progress_bar != null:
				progress_bar.visible = true
		var old_life = _current_life_counter
		# Clamp value between 0 and initial_life_counter
		# Use clampf for floats
		_current_life_counter = clampf(value, 0.0, initial_life_counter)

		# Update the UI (ProgressBar and Label) only if nodes are ready
		if is_node_ready() and progress_bar:
			progress_bar.value = _current_life_counter
			if life_value_label: # Check if label reference is valid too
				# THIS IS WHERE THE LABEL TEXT IS SET
				# It will show an integer (no decimal) because of round() and str()
				life_value_label.text = str(roundi(_current_life_counter))
				# Optional: For debugging, print what's being set
				print(name, ": Label text updated to: ", life_value_label.text)

		# Emit damage_received signal if life actually changed and decreased
		if _current_life_counter != old_life:
			var damage_dealt = old_life - _current_life_counter
			if damage_dealt > 0: # Only emit if damage was taken
				damage_received.emit(damage_dealt, _current_life_counter)

			# Check for killed condition, emit only once when crossing the threshold
			if _current_life_counter <= 0.0 and old_life > 0.0:
				killed.emit()
	get:
		return _current_life_counter


# Removed progress_bar_position for simplicity, as it wasn't causing the main issue.
# Re-add it using the safe patterns if you need it.


func _ready() -> void:
	life_value_label.visible = not wait_having_some_damage_before_displaying_label_and_progressbar
	progress_bar.visible = not wait_having_some_damage_before_displaying_label_and_progressbar
	# Initialize UI elements using the exported properties.
	# By assigning to `self.current_life_counter`, its setter is called,
	# which correctly updates the ProgressBar and Label.
	
	# Initialize max_value for the progress bar
	# This also uses the initial_life_counter setter's logic,
	# ensuring progress_bar.max_value is updated if progress_bar is ready.
	self.initial_life_counter = initial_life_counter 

	# Initialize current life. This will call the current_life_counter's setter,
	# which in turn updates progress_bar.value and the life_value_label.
	self._current_life_counter = initial_life_counter 

	# --- IMPORTANT DEBUGGING STEP ---
	# In the Godot editor, select your ProgressBar node.
	# In the Inspector, under the "Text" section, UNCHECK "Show Percentage".
	# This removes the ProgressBar's default text, so only your Label is visible.


func _process(_delta: float) -> void:
	# REMOVED: No longer need to update UI every frame here.
	# The setters handle it when the value changes.
	pass


func take_damage(injury_zone_type: InjuryZone.EnumInjuryZoneType, damage_strength: float):
	# This will use the setter of current_life_counter, which handles:
	# - Clamping the new value (0 to initial_life_counter)
	# - Updating the ProgressBar and Label
	# - Emitting damage_received signal
	# - Emitting killed signal
	self.current_life_counter -= damage_strength
