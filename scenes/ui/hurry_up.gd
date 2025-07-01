extends Control
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var hurry_up_label: Label = %HurryUpLabel

var _toggle_label_visibility_ticks_in_msec: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	_connect_to_signals_if_needed()

var _connected_to_signals: bool = false

func _connect_to_signals_if_needed() -> void:
	if _connected_to_signals:
		return
	
	var player_platformer = ToolsSingleton.get_player_platformer()
	
	if player_platformer != null:
		player_platformer.unbury_timer_started.connect(_on_unbury_timer_started)
		player_platformer.unbury_timer_progress.connect(_on_unbury_timer_progress)
		player_platformer.unbury_timer_stopped.connect(_on_unbury_timer_stopped)
		_connected_to_signals = true
	

var _currecntly_displaying_label = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_connect_to_signals_if_needed()
	var now = Time.get_ticks_msec()
	if now > _toggle_label_visibility_ticks_in_msec:
		_currecntly_displaying_label = not _currecntly_displaying_label
		_toggle_label_visibility_ticks_in_msec = now + 2000
		
		if _currecntly_displaying_label:
			hurry_up_label.modulate = Color.WHITE
		else:
			hurry_up_label.modulate = Color.TRANSPARENT
	
func _on_unbury_timer_started(start_ticks_in_msec: int, end_ticks_in_msec: int) -> void:
	visible = true
	progress_bar.min_value = start_ticks_in_msec
	progress_bar.value = start_ticks_in_msec
	progress_bar.max_value = end_ticks_in_msec
	
func _on_unbury_timer_progress(current_ticks_in_msec: int) -> void:
	progress_bar.value = current_ticks_in_msec

func _on_unbury_timer_stopped() -> void:
	visible = false
