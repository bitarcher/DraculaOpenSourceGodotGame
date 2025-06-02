extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var time_ticks = Time.get_ticks_msec()
	var time_diff = time_ticks - GameManagerSingleton.level_start_ticks
	var time_diff_in_sec = time_diff / 1000.0
	var time_diff_in_sec_str_rounded_to_unit = "%d" % round(time_diff_in_sec)
	$Panel/Label.text = time_diff_in_sec_str_rounded_to_unit + " sec."
