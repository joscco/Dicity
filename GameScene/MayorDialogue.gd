extends Control

var tutorialState = 0
var tutorialOver = false
var lastHint = null

var speechBubbleTween = Tween.new()
var hintBubbleTween = Tween.new()
var hintTimer = Timer.new()

func _ready():
	GameManager.showingDialogue = true
	$TutorialSpeechbubble/TutorialText.text = tutorialTexts[0][0]
	$HintSpeechbubble.hide()
	
	add_child(speechBubbleTween)
	add_child(hintBubbleTween)
	add_child(hintTimer)
	
var tutorialTexts = {
	0: ["Hello there 'ol chap. My name is Mayor Diceington of the Dice Dynasty. Would you like me to show you around a bit?",\
		"Alright, splendid. I must confess, I am not made for the life of a mayor. My lifelong dream is to become a competitive Yahtzee player, but alas my family keeps assigning me project after project.",\
		"Would you mind taking over for me? At least for a little while, so I can hone my Yahtzee skills.",\
		"It's not as difficult as it sounds, don't worry. Here, let me show you what to do."],
	1: ["Here you have a little land to train with. The main principle is very easy: Just roll the dice and place them on the land.", \
	 	"If it were up to me, you could place them any way you like but my family gives me these ridiculous productivity quotas to fulfill.", \
		"Black buildings produce money. As a rule of thumb the larger the number, the larger the yield.",\
		"Basically if the city doesn't produce enough money after a certain amount of dice rolls they will come check up on me and then we are busted.", \
		"So be kind and place a few black buildings to fulfill the money demands!"]
}

#"Building a cluster of the same building will increase the yield of all buildings in the cluster.",\
#"But don't just go building huge clusters of factories. Firstly because you need food, entertainment and education to improve your luck with the dice and secondly because large clusters will negatively impact neighboring tiles.",\
#"Nobody wants to live right next to a giant factory complex, right? But then again, I wouldn't want to live right next to a huge cluster of kindergartens either. Everything in moderation, I guess.",\
#"Also if your city has no food, entertainment or education at the end of the turn my family will know right away.",\
#"Use the buttons on the left to change the color of a die or to reroll it. How often you can do that is governed by your city's education and entertainment level respectively. Your city's food influences how many dice you get each round.",\
#"I'm sure you'll get the hang of it in no time.",\
#"Thank you so much, I'll be off practicing. Good luck!"

var hintTexts =[\
"The chance to get a Yahtzee on the first roll are only 0.0771% but with enough skill a practiced player can improve those odds to 1 in 1296.",\
"Yahtzee!!",\
"Dammit I need a 4",\
"Remember you don't need to place all dice.",\
"The sound of rolling dice is like music in my ears.",\
"The earliest dice were made of bone. Spooky.",\
"The most important predecessor of Yahtzee is the dice game Yacht, which is an English cousin of Generala and dates back to at least 1938.",\
"My biggest weakness is the Full House.",\
"The chance to get a Yahtzee with the rerolls is 4.6%.",\
"One of the oldest known dice games is Senet. It was played before 3000 BC.",\
"The five dot pattern on many dice is called Quincunx.",\
"A [3] is worth 3 points, [3][3] is worth 12 points and [3][3][3] is worth 27 points. How does that work? Nobody knows.",\
"Sometimes late at night I wonder if I'm just part of a bigger dice game that somebody else is playing.",\
"Some people consider a coin a two sided die. Those people have lost their grasp on reality.",\
"Nothing beats playing dice for hours on end.",\
"The average Yahtzee score when using the perfect strategy is 254.59.",\
"The highest possible Yahtzee score is 1,575.",\
"Industry has the highest impact on food and the lowest on entertainment.",\
"Forming a cluster will decrease the yield of neighboring buildings of a different color.",\
"Hi there Mark Brown.",\
"Every new city my family assigns me has more mountains and a higher quota. It's like they want me to fail eventually."
]

func next():
	if tutorialOver:
		return
		
	tutorialState += 1

	if tutorialState < tutorialTexts[GameManager.level].size():
		GameManager.showingDialogue = true
		$TutorialSpeechbubble/TutorialText.text = tutorialTexts[GameManager.level][tutorialState]
	else:
		tutorialState = -1
		
		if GameManager.level == 0:
			GameManager.levelUp()

		if GameManager.level >= 5:
			closeTutorial()
		else:
			next()

func closeTutorial():
	speechBubbleTween.interpolate_property($TutorialSpeechbubble, "rect_scale", null, Vector2(1, 0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	speechBubbleTween.start()
	yield(speechBubbleTween, "tween_completed")
	$TutorialSpeechbubble.hide()
	tutorialOver = true
	startHintTimer()
	GameManager.showingDialogue = false
	GameManager.inTutorial = false
	
func startHintTimer():
	hintTimer.stop()
	hintTimer.start(20)
	yield(hintTimer, "timeout")
	hint()
	yield(hintBubbleTween, "tween_completed")
	hintTimer.stop()
	hintTimer.start(6)
	yield(hintTimer, "timeout")
	closeHint()
	
func closeHint():
	hintBubbleTween.interpolate_property($HintSpeechbubble, "rect_scale", null, Vector2(1, 0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	hintBubbleTween.start()
	yield(hintBubbleTween, "tween_completed")
	$HintSpeechbubble.hide()
	startHintTimer()
	
func hint():
	if tutorialOver:
		SoundManager.playSound('plop')
		var hintIndex = randi() % hintTexts.size()
		while hintIndex == lastHint:
			hintIndex = randi() % hintTexts.size()
		lastHint = hintIndex
		
		$HintSpeechbubble.show()
		$HintSpeechbubble/HintText.text = hintTexts[hintIndex]
		hintBubbleTween.interpolate_property($HintSpeechbubble, "rect_scale", null, Vector2(1,1), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		hintBubbleTween.start()
		
