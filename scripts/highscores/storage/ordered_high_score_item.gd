class_name OrderedHighScoreItem

@export var position_zero_based:int
@export var item: HighScoreItem

func _init(p_item: HighScoreItem = null, p_position: int = 0):
	item = p_item
	position_zero_based = p_position

func get_position_one_based() -> int:
	return position_zero_based + 1
