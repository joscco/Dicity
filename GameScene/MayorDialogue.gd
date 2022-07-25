extends Control

var tutorialTexts = {
	0: ["Hello there 'ol chap. My name is Mayor Diceington of the Dice Dynasty. Would you like me to show you around a bit?",\
		"Alright, splendid. I must confess, I am not made for the life of a mayor. My lifelong dream is to become a competitive Yahtzee player, but my family keeps assigning me project after project.",\
		"Would you mind taking over for me? At least for a little while, so I can hone my Yahtzee skills."],
	1: ["Here you have a little land to train with. The main idea: Roll the dice and place them on the land.", \
	 	"If it were up to me, you could place them any way you like but my family gives me these ridiculous productivity quotas to fulfill.", \
		"Black buildings produce money. The larger the number, the larger the yield.",\
		"Basically if the city doesn't produce enough money after a certain amount of dice rolls they will come check up on me and then we are busted.", \
		"So be kind and place a few black buildings to fulfill the money demands!"],
	2: ["Great, that seems to work! Then let's go to the next step, building clusters.",\
		"A cluster is formed by two or more buildings of same type and number placed next to each other.",\
		"You can see a food cluster of buildings with number 6 above already!",\
		"Building a cluster of the same building will increase the yield of all buildings in that cluster immensely.",\
		"Now try to make your own cluster to get us some money."],
	3: ["Awesome! Now the mountains are gone too, more space to build stuff, yeah!",
		"But don't just go building huge clusters of factories. Large clusters will negatively impact neighboring tiles.",
		"Nobody wants to live right next to a giant factory complex, right? But then again, I wouldn't want to live right next to a huge cluster of kindergartens either. Everything in moderation, I guess.",
		"See yourself what happens if you build a factory cluster next to the food cluster"],
	4: ["Well, looks like that factory cluster gave the food cluster a little knock down.", 
		"And know we need even more money but have no space left! Urgh.",
		"Looks like we have to bulldoze some of these food buildings to make room for new factories. Could you do that? There's a button for that right below me. Just press it and select the building you want to tear down."],
	5: ["Hello there new freedom! Well done!", "Now to the other things you can do: Apart from the bulldozer you can find other buttons to throw new dice, change the color of a die or to reroll it below me.",
		"How often you can do these actions is governed by your city's education and entertainment level respectively. Your city's food influences how many dice you get each round.", 
		"You normally get 10 dice rolls per level, but since you're still learning, we'll give you 100 here.",
		"Now try to reach the money quota with all these fancy buttons"],
	6: ["Superb, you did it! Then let me just give you some final strategic words.",
		"If your city has no food, entertainment or education at the end of a turn my family will know right away.",
		"This town here has a lot of factories and makes good money but education, food and fun is greatly in danger.",
		"Save this town and then you'll be ready for the real game! Thanks in advance."]
}

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

var tutorialLevel = 0
var tutorialState = 0
var lastHint = null

var initialPositionHint

var speechBubbleTween = Tween.new()
var hintBubbleTween = Tween.new()
var hintTimer = Timer.new()

func _ready():
	GameManager.showingDialogue = true
	GameManager.setMayor(self)
	$TutorialSpeechbubble/TutorialText.text = tutorialTexts[0][0]
	$HintSpeechbubble.hide()
	$TutorialSpeechbubble/TutorialPrevButton.hide()
	
	initialPositionHint = $HintSpeechbubble.rect_position
	
	add_child(speechBubbleTween)
	add_child(hintBubbleTween)
	add_child(hintTimer)
	
func prev():
	tutorialState -= 1
	$TutorialSpeechbubble/TutorialNextButton.show()
	$TutorialSpeechbubble/TutorialPrevButton.show()
	GameManager.showingDialogue = true

	if tutorialState < 0:
		if tutorialLevel == 0:
			tutorialState = 0
		else:
			tutorialLevel -= 1
			tutorialState = tutorialTexts[tutorialLevel].size() - 1
		
		GameManager.showTutorialLevel(tutorialLevel)
		
	if tutorialLevel == 0 and tutorialState == 0:
		$TutorialSpeechbubble/TutorialPrevButton.hide()
	
	$TutorialSpeechbubble/TutorialText.text = tutorialTexts[tutorialLevel][tutorialState]
	
func nextTutorialLevel():
	var currentTutorialLevel = tutorialLevel
	while tutorialLevel == currentTutorialLevel:
		next()
	
func next():
	tutorialState +=1
	$TutorialSpeechbubble/TutorialNextButton.show()
	$TutorialSpeechbubble/TutorialPrevButton.show()

	if tutorialState >= tutorialTexts[tutorialLevel].size():
		tutorialLevel += 1
		tutorialState = -1
		
		if tutorialLevel > 6:
			closeTutorial()
		else:
			GameManager.showTutorialLevel(tutorialLevel)
			next()
	else:
		GameManager.showingDialogue = true
		$TutorialSpeechbubble/TutorialText.text = tutorialTexts[tutorialLevel][tutorialState]
		if tutorialLevel > 0 and tutorialState == tutorialTexts[tutorialLevel].size() - 1:
			$TutorialSpeechbubble/TutorialNextButton.hide()
			GameManager.showingDialogue = false

func closeTutorial():
	GameManager.inTutorial = false
	speechBubbleTween.interpolate_property($TutorialSpeechbubble, "rect_scale", null, Vector2(1, 0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	speechBubbleTween.start()
	yield(speechBubbleTween, "tween_completed")
	$TutorialSpeechbubble.hide()
	startHintTimer()
	GameManager.startNewGame()
	GameManager.showingDialogue = false
	
func startHintTimer():
	hintTimer.stop()
	hintTimer.start(20)
	yield(hintTimer, "timeout")
	newHint()
	yield(hintBubbleTween, "tween_completed")
	hintTimer.stop()
	hintTimer.start(6)
	yield(hintTimer, "timeout")
	closeHint()
	
func closeHint():
	hintBubbleTween.interpolate_property($HintSpeechbubble, "rect_position", null, initialPositionHint + Vector2(0, 400), 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	hintBubbleTween.start()
	yield(hintBubbleTween, "tween_completed")
	$HintSpeechbubble.hide()
	startHintTimer()
	
func newHint():
	SoundManager.playSound('plop')
	var hintIndex = randi() % hintTexts.size()
	while hintIndex == lastHint:
		hintIndex = randi() % hintTexts.size()
	lastHint = hintIndex
	
	$HintSpeechbubble.show()
	$HintSpeechbubble/HintText.text = hintTexts[hintIndex]
	hintBubbleTween.interpolate_property($HintSpeechbubble, "rect_position", null, initialPositionHint, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	hintBubbleTween.start()
		
