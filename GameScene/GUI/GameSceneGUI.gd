extends CanvasLayer

onready var moneyBar: TextureProgress = $MoneyBar
onready var LevelCount: Label = $MoneyBar/LevelCountBack/LevelCount

onready var foodBar: TextureProgress = $HBoxContainer/FoodBar
onready var educationBar: TextureProgress = $HBoxContainer/EducationBar
onready var funBar: TextureProgress = $HBoxContainer/FunBar

func _progress(_delta):
	moneyBar.value = 100 * GameManager.industry / GameManager.moneyToEarn
	foodBar.value = 100 * GameManager.food / GameManager.foodNeeded
	educationBar.value = 100 * GameManager.education / GameManager.educationNeeded
	funBar.value = 100 * GameManager.funNeeded / GameManager.funNeeded
	
