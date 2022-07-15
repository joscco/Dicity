extends CanvasLayer

onready var hpCount = $HPCount
onready var ammoCount = $AmmoCount
onready var levelBar: TextureProgress = $LevelBar
onready var levelCount = $LevelCountBack/LevelCount

func _process(delta):
	hpCount.text = str(GameManager.hp)
	ammoCount.text = str(GameManager.ammo)
	levelBar.value = 100 * (float(GameManager.xp) / float(GameManager.getRequiredXP()))
	levelCount.text = str(GameManager.level)
