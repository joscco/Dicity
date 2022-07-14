extends CanvasLayer

onready var player = get_node("../Characters/Player")
onready var ammoCount = $MarginContainer/AmmoCount

func _process(delta):
	ammoCount.text = str(GameManager.ammo)
