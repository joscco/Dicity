extends CanvasLayer

const adaptationSpeed = 0.1
signal level_up_screen_done

onready var moneyBar: TextureProgress = $MoneyBar
onready var levelCount: Label = $MoneyBar/LevelCountBack/LevelCount

onready var foodBar: TextureProgress = $HBoxContainer/Food/FoodBar
onready var educationBar: TextureProgress = $HBoxContainer/Education/EducationBar
onready var funBar: TextureProgress = $HBoxContainer/Fun/FunBar

onready var foodEffectLabel: Label = $HBoxContainer/Food/Effects/Num
onready var educationEffectLabel: Label = $HBoxContainer/Education/Effects/Num
onready var funEffectLabel: Label= $HBoxContainer/Fun/Effects/Num

var tween: Tween = Tween.new()

onready var levelUpScreen : TextureRect = $LevelUpScreen
var levelUpTween: Tween = Tween.new()

var changingLevelCount = false

func _ready():

	add_child(tween)
	add_child(levelUpTween)
	GameManager.setGUIManager(self)
	levelUpScreen.rect_scale = Vector2.ZERO
	
func on_level_up():
	levelUpTween.interpolate_property(levelUpScreen, "rect_scale", null, Vector2(1,1), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	levelUpTween.start()
	yield(levelUpTween, "tween_completed")
	yield(get_tree().create_timer(2.0), "timeout")
	levelUpTween.interpolate_property(levelUpScreen, "rect_scale", null, Vector2.ZERO, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	levelUpTween.start()
	yield(levelUpTween, "tween_completed")
	emit_signal("level_up_screen_done")

func _process(_delta):
	foodEffectLabel.text = str(GameManager.diceCount)
	educationEffectLabel.text = str(GameManager.typeChangesLeft)
	funEffectLabel.text = str(GameManager.diceRerollsLeft)
	
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
