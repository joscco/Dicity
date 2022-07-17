extends CanvasLayer

const adaptationSpeed = 0.1

onready var moneyBar: TextureProgress = $MoneyBar
onready var LevelCount: Label = $MoneyBar/LevelCountBack/LevelCount

onready var foodBar: TextureProgress = $HBoxContainer/FoodBar
onready var educationBar: TextureProgress = $HBoxContainer/EducationBar
onready var funBar: TextureProgress = $HBoxContainer/FunBar

func _process(_delta):
	var desiredMoneyBarValue = GameManager.getMoneyPercent()
	var desiredFoodBarValue = GameManager.getFoodPercent()
	var desiredEducationBarValue = GameManager.getEducationPercent()
	var desiredFunBarValue = GameManager.getFunPercent()
	

	moneyBar.value = lerp(moneyBar.value, desiredMoneyBarValue, adaptationSpeed)
	foodBar.value = lerp(foodBar.value, desiredFoodBarValue, adaptationSpeed)
	educationBar.value = lerp(educationBar.value, desiredEducationBarValue, adaptationSpeed)
	funBar.value = lerp(funBar.value, desiredFunBarValue, adaptationSpeed)
	
