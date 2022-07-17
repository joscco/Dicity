extends CanvasLayer

onready var moneyBar: TextureProgress = $MoneyBar
onready var LevelCount: Label = $MoneyBar/LevelCountBack/LevelCount

onready var foodBar: TextureProgress = $HBoxContainer/FoodBar
onready var educationBar: TextureProgress = $HBoxContainer/EducationBar
onready var funBar: TextureProgress = $HBoxContainer/FunBar

func _process(_delta):
	moneyBar.value = lerp(moneyBar.value, 100 * GameManager.money / GameManager.getMoneyNeededForThisLevel(), 0.1)
	foodBar.value = lerp(foodBar.value, 100 * GameManager.food / GameManager.foodNeeded, 0.1)
	educationBar.value = lerp(educationBar.value, 100 * GameManager.education / GameManager.educationNeeded, 0.1)
	funBar.value = lerp(funBar.value, 100 * GameManager.fun / GameManager.funNeeded, 0.1)
	
