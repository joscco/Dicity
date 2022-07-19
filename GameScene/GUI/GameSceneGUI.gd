extends CanvasLayer

const adaptationSpeed = 0.1
signal level_up_screen_done

onready var roundsLeftLabel : Label = $MoneyBar/Num
onready var percentageDisplay : Label = $MoneyBar/PointsDisplay

onready var moneyBar: TextureProgress = $MoneyBar
onready var levelCount: Label = $MoneyBar/LevelCountBack/LevelCount

onready var foodBar: TextureProgress = $HBoxContainer/Food/FoodBar
onready var educationBar: TextureProgress = $HBoxContainer/Education/EducationBar
onready var funBar: TextureProgress = $HBoxContainer/Fun/FunBar

onready var foodPercentLabel: Label = $HBoxContainer/Food/FoodBar/PointsDisplay
onready var educationPercentLabel: Label = $HBoxContainer/Education/EducationBar/PointsDisplay
onready var funPercentLabel: Label= $HBoxContainer/Fun/FunBar/PointsDisplay

onready var foodEffectLabel: Label = $HBoxContainer/Food/Effects/Num
onready var educationEffectLabel: Label = $HBoxContainer/Education/Effects/Num
onready var funEffectLabel: Label= $HBoxContainer/Fun/Effects/Num

# These bars only accept int values, so lerping leads to errors
var moneyBarFloatValue : float = 0
var foodBarFloatValue: float = 0
var funBarFloatValue: float = 0
var educationBarFloatValue: float = 0

var tween: Tween = Tween.new()

onready var levelUpScreen : TextureRect = $LevelUpScreen
var levelUpTween: Tween = Tween.new()

var changingLevelCount = false

func _ready():
	
	add_child(tween)
	add_child(levelUpTween)
	GameManager.setGUIManager(self)
	levelUpScreen.show()
	levelUpScreen.rect_scale = Vector2.ZERO
	
func on_level_up():
	levelUpTween.interpolate_property(levelUpScreen, "rect_scale", null, Vector2(1,1), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	levelUpTween.start()
	yield(levelUpTween, "tween_completed")
	levelUpTween.interpolate_property(levelUpScreen, "rect_scale", null, Vector2.ZERO, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	levelUpTween.start()
	yield(levelUpTween, "tween_completed")
	emit_signal("level_up_screen_done")

func _process(_delta):
	
	roundsLeftLabel.text = str(clamp(10 - GameManager.rollsLeft + 1, 0, 10)) + "/10"
	percentageDisplay.text = str(GameManager.money) + "/" + str(GameManager.getMoneyNeededForThisLevel())
	
	foodEffectLabel.text = str(GameManager.diceCount)
	educationEffectLabel.text = str(GameManager.typeChangesLeft)
	funEffectLabel.text = str(GameManager.numberChangesLeft)
	
	foodPercentLabel.text = str(int(GameManager.getFoodPercent())) + "/100"
	educationPercentLabel.text = str(int(GameManager.getEducationPercent())) + "/100"
	funPercentLabel.text = str(int(GameManager.getFunPercent())) + "/100"
	
	var desiredMoneyBarValue = clamp(GameManager.getMoneyPercent(), 0, 100)
	var desiredFoodBarValue = clamp(GameManager.getFoodPercent(), 0, 100)
	var desiredEducationBarValue = clamp(GameManager.getEducationPercent(), 0, 100)
	var desiredFunBarValue = clamp(GameManager.getFunPercent(), 0, 100)

	moneyBarFloatValue = lerp(moneyBarFloatValue, desiredMoneyBarValue, adaptationSpeed)
	foodBarFloatValue = lerp(foodBarFloatValue, desiredFoodBarValue, adaptationSpeed)
	educationBarFloatValue = lerp(educationBarFloatValue, desiredEducationBarValue, adaptationSpeed)
	funBarFloatValue = lerp(funBarFloatValue, desiredFunBarValue, adaptationSpeed)
	
	moneyBar.value = moneyBarFloatValue
	foodBar.value = foodBarFloatValue
	educationBar.value = educationBarFloatValue
	funBar.value = funBarFloatValue
	
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
