extends Camera2D

onready var player = get_node("../Player")
onready var ammoCount = $AmmoCount

func _process(delta):
	position = player.position
	ammoCount.text = str(player.ammo)
