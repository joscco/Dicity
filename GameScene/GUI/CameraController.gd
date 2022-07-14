extends Camera2D

onready var player = get_node("../Characters/Player")

const OFFSET = 200

func _process(delta):
	position = player.position - Vector2(0, OFFSET)
