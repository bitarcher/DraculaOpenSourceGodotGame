extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var _has_node_sound = false

func _on_body_entered(body: Node) -> void:
	if not _has_node_sound:
		_has_node_sound = true
		var audio = AudioStreamPlayer2D.new()
		var res = "res://assets/sounds/stone-dropping-6843.mp3"
		audio.stream = load(res) 
		add_child(audio)
		audio.play()
	
