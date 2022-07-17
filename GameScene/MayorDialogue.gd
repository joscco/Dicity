extends Node2D

var tutorialState = 0
var tutorialOver = false
var lastHint = null

var speechBubbleTween = Tween.new()
var hintBubbleTween = Tween.new()

func _ready():
	GameManager.showingDialogue = true
	$TutorialSpeechbubble/TutorialText.text = tutorialTexts[0]
	$HintSpeechbubble.hide()
	
	add_child(speechBubbleTween)
	add_child(hintBubbleTween)

	
var tutorialTexts = [\
"Hello there 'ol chap. My name is Mayor Diceington of the Dice Dynasty. I must confess, I am not made for the life of a mayor. My lifelong dream is to become a competitive Yahtzee player, but alas my family keeps assigning me project after project.",\
"Would you mind taking over for me? At least for a little while, so I can hone my Yahtzee skills.",\
"Its not as difficult as it looks. Just roll the dice and place them on the land. If it were up to me, you could place them any way you like but my family gives me these ridiculous productivity quotas to fulfill.",\
"Basically if the city doesn't produce enough money after a certain amount of dice rolls they will come check up on me and then we are busted.",\
"Black buildings produce money. As a rule of thumb the larger the number, the larger the yield. Building a cluster of the same building will increase the yield of all buildings in the cluster.",\
"But don't just go building huge clusters of factories. Firstly because you need food, entertainment and education to improve your luck with the dice and secondly because large clusters will negatively impact neighboring tiles.",\
"Nobody wants to live right next to a giant factory complex, right? But then again, I wouldn't want to live right next to a huge cluster of kindergartens either. Everything in moderation, I guess.",\
"Also if your city has no food, entertainment or education at the end of the turn my family will know right away.",\
"Use the buttons on the left to change the color of a die or to reroll it. How often you can do that is governed by your city's education and entertainment level respectively. Your city's food influences how many dice you get each round.",\
"I'm sure you'll get the hang of it in no time.",\
"Thank you so much, I'll be off practicing. Good luck!"
]


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

var hintAnswers=[\
'[center]ahh...[/center]',\
'[center]fascinating[/center]',\
"[center]damn that's crazy[/center]",\
'[center]cool cool cool[/center]',\
'[center]wow[/center]',\
'[center]ok[/center]',\
'[center]whatever[/center]',\
]



func next():
	tutorialState += 1
	if not tutorialOver and tutorialState < tutorialTexts.size():
		GameManager.showingDialogue = true
		$TutorialSpeechbubble/TutorialText.text = tutorialTexts[tutorialState]
	else:
		tutorialOver = true
		
		speechBubbleTween.interpolate_property($TutorialSpeechbubble, "scale", null, Vector2(0,0), 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		speechBubbleTween.start()
		hintBubbleTween.interpolate_property($HintSpeechbubble, "scale", null, Vector2(0,0), 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		hintBubbleTween.start()
		yield(speechBubbleTween, "tween_completed")
		$TutorialSpeechbubble.hide()
		$HintSpeechbubble.hide()

		GameManager.showingDialogue = false

func hint():
	if tutorialOver:
		SoundManager.playSound('plop')
		GameManager.showingDialogue = true
		var hintIndex = randi() % hintTexts.size()
		while hintIndex == lastHint:
			hintIndex = randi() % hintTexts.size()
		lastHint = hintIndex
		
		$HintSpeechbubble.show()
		$HintSpeechbubble/HintText.text = hintTexts[hintIndex]
		$HintSpeechbubble/HintNextButton/HintAnswer.bbcode_text = hintAnswers[randi()%hintAnswers.size()]
		speechBubbleTween.interpolate_property($TutorialSpeechbubble, "scale", null, Vector2(1,1), 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		hintBubbleTween.interpolate_property($HintSpeechbubble, "scale", null, Vector2(1,1), 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		speechBubbleTween.start()
		hintBubbleTween.start()
		
