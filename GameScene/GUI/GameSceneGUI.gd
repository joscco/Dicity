extends CanvasLayer

const adaptationSpeed = 0.1

onready var moneyBar: TextureProgress = $MoneyBar
onready var levelCount: Label = $MoneyBar/LevelCountBack/LevelCount

onready var foodBar: TextureProgress = $HBoxContainer/FoodBar
onready var educationBar: TextureProgress = $HBoxContainer/EducationBar
onready var funBar: TextureProgress = $HBoxContainer/FunBar

var tween: Tween = Tween.new()
var changingLevelCount = false

func _ready():
	add_child(tween)

func _process(_delta):
	var desiredMoneyBarValue = GameManager.getMoneyPercent()
	var desiredFoodBarValue = GameManager.getFoodPercent()
	var desiredEducationBarValue = GameManager.getEducationPercent()
	var desiredFunBarValue = GameManager.getFunPercent()

	moneyBar.value = lerp(moneyBar.value, desiredMoneyBarValue, adaptationSpeed)
	foodBar.value = lerp(foodBar.value, desiredFoodBarValue, adaptationSpeed)
	educationBar.value = lerp(educationBar.value, desiredEducationBarValue, adaptationSpeed)
	funBar.value = lerp(funBar.value, desiredFunBarValue, adaptationSpeed)
	
	if !changingLevelCount and levelCount.text != str(GameManager.level):
		updateLevelCount()
	
func updateLevelCount():
	changingLevelCount = true
	tween.interpolate_property(levelCount, "rect_scale", null, Vector2.ZERO, 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	levelCount.text = str(GameManager.level)
	tween.interpolate_property(levelCount, "rect_scale", null, Vector2(1, 1), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	changingLevelCount = false
