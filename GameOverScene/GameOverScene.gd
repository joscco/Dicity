extends Node

onready var levelCount = $LevelCount
onready var pointsCount = $PointsCount
onready var reasonForDeathLabel = $ReasonForDeath

func _ready():
	levelCount.text = str(GameManager.level)
	pointsCount.text = str(GameManager.money)
	reasonForDeathLabel.updateText()
	
