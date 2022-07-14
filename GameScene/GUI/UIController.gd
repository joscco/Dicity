extends CanvasLayer

onready var ammoCount = $AmmoCount
onready var levelBar: TextureProgress = $LevelBar
onready var levelCount = $LevelCountBack/LevelCount

func _process(delta):
	ammoCount.text = str(GameManager.ammo)
	levelBar.value = 100 * (float(GameManager.xp) / float(GameManager.get_required_xp()))
	levelCount.text = str(GameManager.level)
