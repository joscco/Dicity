extends Camera2D

onready var player = get_node("../Characters/Player")

func _process(delta):
	position = player.position
